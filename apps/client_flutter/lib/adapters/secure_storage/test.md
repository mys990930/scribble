# secure-storage test

- save 후 read 시 동일 세션 반환
- clear 후 read 결과 null
- 손상된 저장값(필드 일부 누락) → null 처리
- 네이티브 구현은 secure storage key-value store에 동일 키 집합을 기록한다
- device id가 없으면 생성 후 저장하고, 이후 read는 동일 값을 반환한다
