import '../../domain/entities/time_entry.dart';
import '../../domain/repository/time_repository.dart';
import '../datasource/time_remote_datasource.dart';
import '../models/time_model.dart';

class RemoteTimeRepository implements ITimeRepository {
  RemoteTimeRepository._internal();
  static final RemoteTimeRepository instance = RemoteTimeRepository._internal();

  final TimeRemoteDataSource _ds = TimeRemoteDataSource();

  @override
  Future<void> addTimeEntry(TimeEntry entry) async {
    final model = TimeEntryModel(
      id: entry.id,
      userId: entry.userId,
      title: entry.title,
      description: entry.description,
      start: entry.start,
      end: entry.end,
      duration: entry.duration,
    );
    await _ds.addEntry(model);
  }

  @override
  Future<List<TimeEntry>> getEntriesForDate(
    String userId,
    DateTime date,
  ) async {
    final models = await _ds.getEntriesForDate(userId, date);
    return models;
  }
}
