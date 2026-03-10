import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:scribble/adapters/api_client/api_auth_service.dart';

void main() {
  group('ApiAuthService', () {
    test('signIn parses a successful auth response', () async {
      final service = ApiAuthService(
        baseUrl: 'http://localhost:8000',
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.toString(), 'http://localhost:8000/auth/login');
          expect(request.headers['Content-Type'], 'application/json');
          expect(
            jsonDecode(request.body),
            {'email': 'user@example.com', 'password': 'password123'},
          );
          return http.Response(
            jsonEncode({
              'access_token':
                  _jwt({'sub': 'user-1', 'sid': 'session-1', 'type': 'access', 'exp': 2000000000}),
              'refresh_token': 'refresh-token-1',
              'token_type': 'bearer',
            }),
            200,
          );
        }),
      );

      final session = await service.signIn(
        email: 'user@example.com',
        password: 'password123',
      );

      expect(session.userId, 'user-1');
      expect(session.accessToken, isNotEmpty);
      expect(session.refreshToken, 'refresh-token-1');
    });

    test('refresh parses a successful token rotation response', () async {
      final service = ApiAuthService(
        baseUrl: 'http://localhost:8000',
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.toString(), 'http://localhost:8000/auth/refresh');
          expect(jsonDecode(request.body), {'refresh_token': 'refresh-token-1'});
          return http.Response(
            jsonEncode({
              'access_token':
                  _jwt({'sub': 'user-1', 'sid': 'session-1', 'type': 'access', 'exp': 2000000000}),
              'refresh_token': 'refresh-token-2',
              'token_type': 'bearer',
            }),
            200,
          );
        }),
      );

      final session = await service.refresh(refreshToken: 'refresh-token-1');

      expect(session.userId, 'user-1');
      expect(session.refreshToken, 'refresh-token-2');
    });

    test('signOut sends bearer token and accepts 204', () async {
      final service = ApiAuthService(
        baseUrl: 'http://localhost:8000',
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.toString(), 'http://localhost:8000/auth/logout');
          expect(request.headers['Authorization'], 'Bearer access-token-1');
          return http.Response('', 204);
        }),
      );

      await service.signOut(accessToken: 'access-token-1');
    });

    test('401 during signIn maps to API_UNAUTHORIZED', () async {
      final service = ApiAuthService(
        baseUrl: 'http://localhost:8000',
        client: MockClient((_) async => http.Response('', 401)),
      );

      expect(
        () => service.signIn(email: 'user@example.com', password: 'password123'),
        throwsA(isA<StateError>().having((e) => e.message, 'message', 'API_UNAUTHORIZED')),
      );
    });

    test('network failure maps to API_NETWORK_ERROR', () async {
      final service = ApiAuthService(
        baseUrl: 'http://localhost:8000',
        client: MockClient((_) async => throw http.ClientException('boom')),
      );

      expect(
        () => service.refresh(refreshToken: 'refresh-token-1'),
        throwsA(isA<StateError>().having((e) => e.message, 'message', 'API_NETWORK_ERROR')),
      );
    });
  });
}

String _jwt(Map<String, Object?> payload) {
  final header = base64Url.encode(utf8.encode(jsonEncode({'alg': 'none', 'typ': 'JWT'}))).replaceAll('=', '');
  final body = base64Url.encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '');
  return '$header.$body.signature';
}
