// 고정 Quick Tag 팔레트 (테마 교체로 전체 팔레트만 바꿀 수 있게 구성)
class RoutinePalette {
  final int work;   // ex) red
  final int rest;   // ex) green
  final int sleep;  // ex) blue
  const RoutinePalette({
    this.work = 0xFFE53935,  // red 600
    this.rest = 0xFF43A047,  // green 600
    this.sleep = 0xFF1E88E5, // blue 600
  });
}
