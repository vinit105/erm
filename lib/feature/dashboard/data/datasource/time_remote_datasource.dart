import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/time_model.dart';

class TimeRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _col;

  TimeRemoteDataSource()
    : _col = FirebaseFirestore.instance.collection('time_entries');

  Future<void> addEntry(TimeEntryModel entry) async {
    await _col.doc(entry.id).set(entry.toMap());
  }

  Future<List<TimeEntryModel>> getEntriesForDate(
    String userId,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final q = await _col
        .where('userId', isEqualTo: userId)
        .where(
          'start',
          isGreaterThanOrEqualTo: startOfDay.toUtc().toIso8601String(),
        )
        .where('start', isLessThan: endOfDay.toUtc().toIso8601String())
        .orderBy('start', descending: true)
        .get();
    return q.docs
        .map(
          (d) => TimeEntryModel.fromMap(
            Map<String, dynamic>.from(d.data() as Map),
          ),
        )
        .toList();
  }
}
