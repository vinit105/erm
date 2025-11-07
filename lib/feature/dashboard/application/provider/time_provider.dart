import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/error_exception.dart';
import '../../data/models/time_model.dart';
import '../../data/repository/time_repository_impl.dart';
import '../../domain/entities/time_entry.dart';
import '../../domain/repository/time_repository.dart';

class TimerProvider extends ChangeNotifier {
  final String? userId;
  final ITimeRepository _repository;

  TimerProvider(this.userId, [ITimeRepository? repository])
    : _repository = repository ?? RemoteTimeRepository.instance;

  bool _running = false;
  bool _loading = false;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;
  DateTime? _start;

  bool get running => _running;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Duration get elapsed => _elapsed;

  void start() {
    if (userId == null) throw AuthException('User not logged in');

    if (_running) return; // already running

    _running = true;
    // ✅ if paused, resume from previous elapsed time
    _start = DateTime.now().subtract(_elapsed);

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed = DateTime.now().difference(_start!);
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    if (!_running) return;
    _ticker?.cancel();
    _elapsed = DateTime.now().difference(_start!); // keep elapsed
    _running = false;
    notifyListeners();
  }

  Future<void> stopAndSave({
    required String title,
    required String description,
  }) async {
    if (_start == null) return;
    _ticker?.cancel();
    final end = DateTime.now();

    final entry = TimeEntryModel(
      id: const Uuid().v4(),
      userId: userId!,
      title: title,
      description: description,
      start: _start!,
      end: end,
      duration: end.difference(_start!),
    );

    try {
      await _repository.addTimeEntry(entry);
    } catch (e) {
      rethrow;
    } finally {
      _running = false;
      _elapsed = Duration.zero;
      _start = null;
      notifyListeners();
    }
  }

  Future<List<TimeEntry>> getTodayEntries() async {
    if (userId == null) throw AuthException('User not logged in');
    return await _repository.getEntriesForDate(userId!, DateTime.now());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
