# sync_api test

## 성공 케이스

- 유효한 사용자와 디바이스는 push 요청을 보낼 수 있다.
- pull은 cursor 이후 이벤트만 반환한다.
- 동일 `event_id` 재전송은 멱등하게 `accepted` 처리된다.
- 서로 다른 디바이스에서 생성된 변경이 pull로 전파된다.
- tombstone 이벤트가 다른 디바이스로 전달된다.
- sync 완료 후 디바이스의 `last_sync_at`이 갱신된다.
- stale 이벤트도 저장은 되지만 LWW 결과로는 최신 상태를 덮어쓰지 못한다.

## 실패 케이스

- 인증 없이 sync 엔드포인트를 호출할 수 없다.
- 비활성 디바이스는 push/pull을 수행할 수 없다.
- 변조된 cursor는 거부된다.
- 만료된 cursor는 `CURSOR_EXPIRED`를 반환한다.
- 필수 필드가 없는 이벤트는 수락되지 않는다.
