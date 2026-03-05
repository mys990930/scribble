import 'package:scribble/shared/kernel/app_error.dart';

AppError archiveEmptyContentError() => const AppError(
      code: 'ARCHIVE_EMPTY_CONTENT',
      message: 'title and body cannot both be empty',
    );

AppError archiveInvalidCategoryError() => const AppError(
      code: 'ARCHIVE_INVALID_CATEGORY',
      message: 'category cannot be empty',
    );
