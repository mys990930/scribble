import 'app_error.dart';

/// 성공 또는 실패를 표현하는 sealed 타입.
sealed class Result<T> {
  const Result();

  /// 성공이면 value, 실패이면 null.
  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };

  /// 성공이면 null, 실패이면 error.
  AppError? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  /// 성공 값을 변환한다.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success(:final value) => Success(transform(value)),
    Failure(:final error) => Failure(error),
  };

  /// 성공이면 value, 실패이면 fallback 호출.
  T getOrElse(T Function(AppError error) fallback) => switch (this) {
    Success(:final value) => value,
    Failure(:final error) => fallback(error),
  };
}

/// 성공 결과.
final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// 실패 결과.
final class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Failure<T> && other.error == error;

  @override
  int get hashCode => error.hashCode;
}
