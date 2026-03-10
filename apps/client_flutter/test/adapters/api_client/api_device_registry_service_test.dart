import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:scribble/adapters/api_client/api_device_registry_service.dart';
import 'package:scribble/usecases/auth_usecases/auth_session.dart';

class StubMetadataProvider implements DeviceRegistrationMetadataProvider {
  @override
  Future<DeviceRegistrationMetadata> getCurrent() async {
    return const DeviceRegistrationMetadata(
      deviceId: 'device-1',
      platform: 'android',
      name: 'Google Pixel 8',
      appVersion: '1.0.0+1',
    );
  }
}

class RecordingClient extends http.BaseClient {
  RecordingClient(this._handler);

  final Future<http.Response> Function(http.BaseRequest request) _handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _handler(request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }
}

void main() {
  group('ApiDeviceRegistryService', () {
    test('현재 디바이스를 등록한다', () async {
      late http.BaseRequest captured;
      final service = ApiDeviceRegistryService(
        baseUrl: 'http://example.com',
        metadataProvider: StubMetadataProvider(),
        client: RecordingClient((request) async {
          captured = request;
          return http.Response(jsonEncode({'device': {}}), 201);
        }),
      );

      await service.registerCurrentDevice(
        session: AuthSession(
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
          userId: 'user-1',
          expiresAt: DateTime.parse('2026-03-10T10:00:00Z'),
        ),
      );

      expect(captured.url.toString(), 'http://example.com/devices');
      expect(captured.headers['authorization'], 'Bearer access-token');
      expect(captured.headers['content-type'], 'application/json');

      final payload = jsonDecode((captured as http.Request).body) as Map<String, dynamic>;
      expect(payload['device_id'], 'device-1');
      expect(payload['platform'], 'android');
      expect(payload['name'], 'Google Pixel 8');
      expect(payload['app_version'], '1.0.0+1');
    });

    test('401은 API_UNAUTHORIZED로 매핑한다', () async {
      final service = ApiDeviceRegistryService(
        baseUrl: 'http://example.com',
        metadataProvider: StubMetadataProvider(),
        client: RecordingClient((request) async => http.Response('', 401)),
      );

      expect(
        () => service.registerCurrentDevice(
          session: AuthSession(
            accessToken: 'access-token',
            refreshToken: 'refresh-token',
            userId: 'user-1',
            expiresAt: DateTime.parse('2026-03-10T10:00:00Z'),
          ),
        ),
        throwsA(isA<StateError>().having((e) => e.message, 'message', 'API_UNAUTHORIZED')),
      );
    });
  });
}
