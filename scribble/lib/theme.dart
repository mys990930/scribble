// Quick Tag palette mapped to app design tokens
class RoutinePalette {
  final int work;
  final int rest;
  final int sleep;
  const RoutinePalette({
    this.work = 0xFFE6535E, // primary
    this.rest = 0xFF6BBC8A, // tertiary
    this.sleep = 0xFF58C3EC, // accent cool
  });

  const RoutinePalette.fromTokens()
    : work = 0xFFE6535E,
      rest = 0xFF6BBC8A,
      sleep = 0xFF58C3EC;
}
