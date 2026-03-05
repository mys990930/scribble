import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/adapters/share_intent/platform_share_payload.dart';
import 'package:scribble/shared/kernel/app_error.dart';

void main() {
  group('PlatformSharePayload.fromPlatformMap', () {
    test('raw.type=text 파싱', () {
      final payload = PlatformSharePayload.fromPlatformMap({
        'type': 'text',
        'text': 'hello',
      });

      expect(payload.type, SharePayloadType.text);
      expect(payload.text, 'hello');
    });

    test('type 누락시 필드 조합으로 mixed 추론', () {
      final payload = PlatformSharePayload.fromPlatformMap({
        'text': 'hello',
        'url': 'https://example.com',
      });

      expect(payload.type, SharePayloadType.mixed);
    });

    test('mimeType image/* + fileUris면 image', () {
      final payload = PlatformSharePayload.fromPlatformMap({
        'fileUris': ['content://image/1'],
        'mimeType': 'image/png',
      });

      expect(payload.type, SharePayloadType.image);
      expect(payload.fileUris.length, 1);
    });

    test('지원하지 않는 type이면 에러', () {
      expect(
        () => PlatformSharePayload.fromPlatformMap({
          'type': 'unknown',
          'text': 'hello',
        }),
        throwsA(
          isA<AppError>().having(
            (e) => e.code,
            'code',
            'SHARE_INTENT_UNSUPPORTED_TYPE',
          ),
        ),
      );
    });
  });
}
