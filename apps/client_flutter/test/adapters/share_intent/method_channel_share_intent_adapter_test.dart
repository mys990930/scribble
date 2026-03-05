import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/adapters/share_intent/method_channel_share_intent_adapter.dart';
import 'package:scribble/adapters/share_intent/platform_share_payload.dart';
import 'package:scribble/shared/kernel/app_error.dart';
import 'package:scribble/usecases/archive_usecases/shared_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannelShareIntentAdapter.handleIncoming', () {
    test('text만 수신 시 rawText=text 전달', () async {
      SharedContent? captured;
      final adapter = MethodChannelShareIntentAdapter(
        channel: const MethodChannel('scribble/share_intent'),
        handleShare: (content) async {
          captured = content;
        },
      );

      await adapter.handleIncoming(
        PlatformSharePayload(
          type: SharePayloadType.text,
          text: 'hello',
          url: null,
          fileUris: const [],
          mimeType: null,
          sourceApp: null,
          receivedAt: DateTime(2026, 3, 5),
        ),
        category: 'inbox',
      );

      expect(captured, isNotNull);
      expect(captured!.rawText, 'hello');
      expect(captured!.category, 'inbox');
    });

    test('text+url+fileUris를 줄단위로 조합', () async {
      SharedContent? captured;
      final adapter = MethodChannelShareIntentAdapter(
        channel: const MethodChannel('scribble/share_intent'),
        handleShare: (content) async {
          captured = content;
        },
      );

      await adapter.handleIncoming(
        PlatformSharePayload(
          type: SharePayloadType.mixed,
          text: 'hello',
          url: 'https://example.com',
          fileUris: const ['content://a', 'content://b'],
          mimeType: null,
          sourceApp: null,
          receivedAt: DateTime(2026, 3, 5),
        ),
        category: 'web',
      );

      expect(
        captured!.rawText,
        'hello\nhttps://example.com\ncontent://a\ncontent://b',
      );
    });

    test('text/url/fileUris 모두 비면 에러', () async {
      final adapter = MethodChannelShareIntentAdapter(
        channel: const MethodChannel('scribble/share_intent'),
        handleShare: (_) async {},
      );

      expect(
        () => adapter.handleIncoming(
          PlatformSharePayload(
            type: SharePayloadType.text,
            text: '   ',
            url: null,
            fileUris: const [],
            mimeType: null,
            sourceApp: null,
            receivedAt: DateTime(2026, 3, 5),
          ),
          category: 'inbox',
        ),
        throwsA(
          isA<AppError>().having(
            (e) => e.code,
            'code',
            'SHARE_INTENT_EMPTY_PAYLOAD',
          ),
        ),
      );
    });
  });
}
