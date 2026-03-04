/// 10분 단위 정렬 여부 확인.
bool is10MinAligned(DateTime t) =>
    t.minute % 10 == 0 && t.second == 0 && t.millisecond == 0;

/// 10분 단위로 내림 정규화.
DateTime alignTo10Min(DateTime t) => DateTime(
      t.year,
      t.month,
      t.day,
      t.hour,
      (t.minute ~/ 10) * 10,
    );

/// 현재 시각을 10분 내림 정규화.
DateTime nowAligned() => alignTo10Min(DateTime.now());

/// 날짜와 시간을 조합한다.
DateTime combineDateTime(DateTime date, DateTime time) =>
    DateTime(date.year, date.month, date.day, time.hour, time.minute);

/// HH:MM 형식 문자열.
String formatHHMM(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// 같은 연-월-일인지 비교.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
