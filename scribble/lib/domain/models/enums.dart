enum Weekday { MON, TUE, WED, THU, FRI, SAT, SUN }

enum RoutineType { SLEEP, WORK, EAT, PLAY, SELFDEV }

enum QuickTagGroup { WORK, PLAY, SLEEP }

QuickTagGroup groupOf(RoutineType t) {
  switch (t) {
    case RoutineType.SLEEP:
      return QuickTagGroup.SLEEP;
    case RoutineType.WORK:
    case RoutineType.SELFDEV:
      return QuickTagGroup.WORK;
    case RoutineType.EAT:
    case RoutineType.PLAY:
      return QuickTagGroup.PLAY;
  }
}
