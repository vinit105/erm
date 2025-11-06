// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../../data/models/time_entry_model.dart';
// import '../../domain/repositories/time_repository.dart';
// import '../../../core/error/exceptions.dart';
// import 'package:uuid/uuid.dart';
//
// class TimerProvider extends ChangeNotifier {
//   final String? userId;
//   final ITimeRepository _repository; // we will create a concrete impl and inject via optional param or service locator
//
//   TimerProvider(this.userId, [ITimeRepository? repository])
//       : _repository = repository ?? RemoteTimeRepository.instance;
//
//   bool _running = false;
//   Duration _elapsed = Duration.zero;
//   Timer? _ticker;
//   DateTime? _start;
//
//   bool get running => _running;
//   Duration get elapsed => _elapsed;
//
//   void start() {
//     if (userId == null) throw AuthException('User not logged in');
//     if (_running) return;
//     _running = true;
//     _start = DateTime.now();
//     _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
//       _elapsed = DateTime.now().difference(_start!);
//       notifyListeners();
//     });
//     notifyListeners();
//   }
//
//   void pause() {
//     if (!_running) return;
//     _ticker?.cancel();
//     _running = false;
//     notifyListeners();
//   }
//
//   Future<void> stopAndSave({required String title, required String description}) async {
//     if (_start == null) return;
//     _ticker?.cancel();
//     final end = DateTime.now();
//     final entry = TimeEntryModel(
//       id: const Uuid().v4(),
//       userId: userId!,
//       title: title,
//       description: description,
//       start: _start!,
//       end: end,
//       duration: end.difference(_start!),
//     );
//     try {
//       await _repository.addTimeEntry(entry);
//     } catch (e) {
//       rethrow;
//     } finally {
//       _running = false;
//       _elapsed = Duration.zero;
//       _start = null;
//       notifyListeners();
//     }
//   }
//
//   Future<List<TimeEntryModel>> getTodayEntries() async {
//     if (userId == null) throw AuthException('User not logged in');
//     return await _repository.getEntriesForDate(userId!, DateTime.now());
//   }
//
//   @override
//   void dispose() {
//     _ticker?.cancel();
//     super.dispose();
//   }
// }
