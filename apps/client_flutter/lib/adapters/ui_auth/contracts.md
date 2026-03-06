# ui-auth contracts

## AuthGateScreen
- 입력: 없음
- 출력: restoring 상태 UI
- 액션: restoreSession 완료 후 main/login 분기 (라우팅은 shell에서 최종 처리)

## LoginScreen
- 입력: email, password
- 출력: 로그인 성공/실패 UI 상태
- 액션: signIn 호출
