import 'package:scribble/adapters/share_intent/platform_share_payload.dart';

abstract class ShareIntentAdapter {
  PlatformSharePayload parseFromPlatform(Map<String, dynamic> raw);

  Future<void> handleIncoming(
    PlatformSharePayload payload, {
    required String category,
  });
}
