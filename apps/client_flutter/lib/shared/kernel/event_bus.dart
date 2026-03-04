import 'dart:async';

/// 모듈 간 비동기 이벤트 발행/구독 버스.
///
/// 앱 생명주기에 따라 [dispose]를 호출해야 한다.
class EventBus {
  final _controller = StreamController<Object>.broadcast();

  /// 이벤트 발행.
  void publish<T extends Object>(T event) {
    if (_controller.isClosed) return;
    _controller.add(event);
  }

  /// 특정 타입 이벤트 구독.
  Stream<T> on<T extends Object>() =>
      _controller.stream.where((e) => e is T).cast<T>();

  /// 리소스 해제.
  void dispose() {
    _controller.close();
  }
}
