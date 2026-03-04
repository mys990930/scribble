bool is10MinAligned(DateTime t) =>
    t.minute % 10 == 0 && t.second == 0 && t.millisecond == 0;

void validateRoutineTimes(DateTime start, DateTime end) {
  if (!is10MinAligned(start) || !is10MinAligned(end)) {
    throw ArgumentError('Routine times must align to 10-minute marks');
  }
  if (!end.isAfter(start)) {
    throw ArgumentError('endTime must be after startTime');
  }
}

void validateNoOverlap(Iterable<DateTime> starts, Iterable<DateTime> ends) {
  final zipped =
      starts
          .toList()
          .asMap()
          .entries
          .map((e) => MapEntry(e.key, e.value))
          .map(
            (e) =>
                ({'i': e.key, 'start': e.value, 'end': ends.elementAt(e.key)}),
          )
          .toList()
        ..sort(
          (a, b) => (a['start'] as DateTime).compareTo(b['start'] as DateTime),
        );
  for (var i = 1; i < zipped.length; i++) {
    final prev = zipped[i - 1];
    final cur = zipped[i];
    if ((cur['start'] as DateTime).isBefore(prev['end'] as DateTime)) {
      throw ArgumentError('Routines overlap at index ${cur['i']}');
    }
  }
}
