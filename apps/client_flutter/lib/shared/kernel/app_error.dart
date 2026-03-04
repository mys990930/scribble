/// 앱 전역 에러 모델.
///
/// 에러 코드 컨벤션: `{MODULE}_{ERROR_NAME}`
/// 예: `MEMO_EMPTY_CONTENT`, `KERNEL_UNEXPECTED`
class AppError implements Exception {
  /// 에러 코드 (예: `MEMO_EMPTY_CONTENT`).
  final String code;

  /// 사람 읽기용 메시지.
  final String message;

  /// 원인 예외 (선택).
  final Object? cause;

  const AppError({
    required this.code,
    required this.message,
    this.cause,
  });

  @override
  String toString() => 'AppError($code: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppError && other.code == code && other.message == message;

  @override
  int get hashCode => Object.hash(code, message);
}

// ── 공통 에러 ──

AppError unexpectedError([Object? cause]) => AppError(
      code: 'KERNEL_UNEXPECTED',
      message: 'An unexpected error occurred',
      cause: cause,
    );

AppError invalidIdError(String id) => AppError(
      code: 'KERNEL_INVALID_ID',
      message: 'Invalid entity ID: $id',
    );
