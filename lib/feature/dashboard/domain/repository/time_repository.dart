import '../entities/time_entry.dart';

abstract class ITimeRepository {
  Future<void> addTimeEntry(TimeEntry entry);
  Future<List<TimeEntry>> getEntriesForDate(String userId, DateTime date);
}
