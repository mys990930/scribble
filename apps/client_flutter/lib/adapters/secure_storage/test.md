# secure-storage test

- save 후 read 시 동일 세션 반환
- clear 후 read 결과 null
- 손상된 저장값(필드 일부 누락) → null 처리
