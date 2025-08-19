DateTime combineDate(DateTime date, DateTime time) =>
  DateTime(date.year, date.month, date.day, time.hour, time.minute);
String hhmm(DateTime t) => '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
