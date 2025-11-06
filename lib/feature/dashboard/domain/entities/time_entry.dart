class TimeEntry {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final Duration duration;

  TimeEntry({
    required this.id,
    required this.userId,
    required this.title,
    this.description = '',
    required this.start,
    required this.end,
    required this.duration,
  });
}
