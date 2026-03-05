import 'package:scribble/shared/kernel/app_error.dart';

AppError shareIntentEmptyPayloadError() => const AppError(
      code: 'SHARE_INTENT_EMPTY_PAYLOAD',
      message: 'Share payload is empty',
    );

AppError shareIntentUnsupportedTypeError(String type) => AppError(
      code: 'SHARE_INTENT_UNSUPPORTED_TYPE',
      message: 'Unsupported share payload type: $type',
    );
