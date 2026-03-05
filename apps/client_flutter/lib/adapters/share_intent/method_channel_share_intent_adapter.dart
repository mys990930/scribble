import 'package:flutter/services.dart';
import 'package:scribble/adapters/share_intent/platform_share_payload.dart';
import 'package:scribble/adapters/share_intent/share_intent_adapter.dart';
import 'package:scribble/adapters/share_intent/share_intent_errors.dart';
import 'package:scribble/usecases/archive_usecases/shared_content.dart';

class MethodChannelShareIntentAdapter implements ShareIntentAdapter {
  final MethodChannel _channel;
  final Future<void> Function(SharedContent content) _handleShare;

  MethodChannelShareIntentAdapter({
    required MethodChannel channel,
    required Future<void> Function(SharedContent content) handleShare,
  })  : _channel = channel,
        _handleShare = handleShare;

  @override
  PlatformSharePayload parseFromPlatform(Map<String, dynamic> raw) {
    return PlatformSharePayload.fromPlatformMap(raw);
  }

  @override
  Future<void> handleIncoming(
    PlatformSharePayload payload, {
    required String category,
  }) async {
    final rawText = _composeRawText(payload);
    if (rawText.isEmpty) {
      throw shareIntentEmptyPayloadError();
    }

    await _handleShare(
      SharedContent(
        rawText: rawText,
        category: category,
      ),
    );
  }

  Future<void> consumePendingAndHandle({required String category}) async {
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'consumePendingShare',
    );
    if (raw == null) return;

    final payload = parseFromPlatform(raw);
    await handleIncoming(payload, category: category);
  }

  String _composeRawText(PlatformSharePayload payload) {
    final lines = <String>[];

    final text = payload.text?.trim();
    final url = payload.url?.trim();

    if (text != null && text.isNotEmpty) {
      lines.add(text);
    }
    if (url != null && url.isNotEmpty) {
      lines.add(url);
    }

    for (final fileUri in payload.fileUris) {
      final normalized = fileUri.trim();
      if (normalized.isNotEmpty) {
        lines.add(normalized);
      }
    }

    return lines.join('\n').trim();
  }
}
