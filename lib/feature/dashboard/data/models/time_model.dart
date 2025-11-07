import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/time_entry.dart';

class TimeEntryModel extends TimeEntry {
  TimeEntryModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.start,
    required super.end,
    required super.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
      'duration': duration.inSeconds,
    };
  }

  factory TimeEntryModel.fromMap(Map<String, dynamic> map) {
    return TimeEntryModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      start: (map['start'] as Timestamp).toDate(),
      end: (map['end'] as Timestamp).toDate(),
      duration: Duration(seconds: map['duration']),
    );
  }
}
