import '../../domain/entities/time_entry.dart';

class TimeEntryModel extends TimeEntry {
  TimeEntryModel({
    required String id,
    required String userId,
    required String title,
    String? description,
    required DateTime start,
    required DateTime end,
    required Duration duration,
  }) : super(
         id: id,
         userId: userId,
         title: title,
         description: description ?? '',
         start: start,
         end: end,
         duration: duration,
       );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'start': start.toUtc().toIso8601String(),
      'end': end.toUtc().toIso8601String(),
      'durationSeconds': duration.inSeconds,
    };
  }

  factory TimeEntryModel.fromMap(Map<String, dynamic> map) {
    final start = DateTime.parse(map['start']).toLocal();
    final end = DateTime.parse(map['end']).toLocal();
    return TimeEntryModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'] ?? '',
      start: start,
      end: end,
      duration: Duration(seconds: map['durationSeconds'] ?? 0),
    );
  }
}
