/// A calendar day as `yyyy-MM-dd`, e.g. `2026-09-30`.
String isoDate(DateTime day) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${day.year}-${two(day.month)}-${two(day.day)}';
}
