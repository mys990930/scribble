import 'package:scribble/adapters/share_intent/share_intent_errors.dart';

enum SharePayloadType {
  text,
  url,
  image,
  file,
  mixed,
}

class PlatformSharePayload {
  final SharePayloadType type;
  final String? text;
  final String? url;
  final List<String> fileUris;
  final String? mimeType;
  final String? sourceApp;
  final DateTime receivedAt;

  const PlatformSharePayload({
    required this.type,
    required this.text,
    required this.url,
    required this.fileUris,
    required this.mimeType,
    required this.sourceApp,
    required this.receivedAt,
  });

  factory PlatformSharePayload.fromPlatformMap(Map<String, dynamic> raw) {
    final rawType = (raw['type'] as String?)?.trim().toLowerCase();
    final text = (raw['text'] as String?)?.trim();
    final url = (raw['url'] as String?)?.trim();
    final mimeType = (raw['mimeType'] as String?)?.trim();
    final sourceApp = (raw['sourceApp'] as String?)?.trim();

    final fileUris = ((raw['fileUris'] as List<dynamic>?) ?? const <dynamic>[])
        .map((e) => e.toString().trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    final type = _resolveType(
      rawType: rawType,
      text: text,
      url: url,
      fileUris: fileUris,
      mimeType: mimeType,
    );

    return PlatformSharePayload(
      type: type,
      text: text?.isEmpty == true ? null : text,
      url: url?.isEmpty == true ? null : url,
      fileUris: fileUris,
      mimeType: mimeType?.isEmpty == true ? null : mimeType,
      sourceApp: sourceApp?.isEmpty == true ? null : sourceApp,
      receivedAt: DateTime.now(),
    );
  }

  static SharePayloadType _resolveType({
    required String? rawType,
    required String? text,
    required String? url,
    required List<String> fileUris,
    required String? mimeType,
  }) {
    if (rawType != null && rawType.isNotEmpty) {
      switch (rawType) {
        case 'text':
          return SharePayloadType.text;
        case 'url':
          return SharePayloadType.url;
        case 'image':
          return SharePayloadType.image;
        case 'file':
          return SharePayloadType.file;
        case 'mixed':
          return SharePayloadType.mixed;
        default:
          throw shareIntentUnsupportedTypeError(rawType);
      }
    }

    final hasText = text != null && text.isNotEmpty;
    final hasUrl = url != null && url.isNotEmpty;
    final hasFiles = fileUris.isNotEmpty;

    if ((hasText && hasUrl) || (hasText && hasFiles) || (hasUrl && hasFiles)) {
      return SharePayloadType.mixed;
    }
    if (hasUrl) return SharePayloadType.url;
    if (hasText) return SharePayloadType.text;
    if (hasFiles) {
      if (mimeType != null && mimeType.startsWith('image/')) {
        return SharePayloadType.image;
      }
      return SharePayloadType.file;
    }

    return SharePayloadType.text;
  }
}
