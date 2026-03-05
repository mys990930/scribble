import 'package:scribble/shared/kernel/app_error.dart';

AppError archiveNotFoundError(String archiveId) => AppError(
      code: 'ARCHIVE_NOT_FOUND',
      message: 'Archive not found: $archiveId',
    );
