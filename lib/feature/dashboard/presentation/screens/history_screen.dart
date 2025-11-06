import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../application/provider/time_provider.dart';
import '../../data/models/time_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<TimeEntryModel>> _future;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TimerProvider>(context, listen: false);
    _future = provider.getTodayEntries().then(
      (list) => list.cast<TimeEntryModel>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today History')),
      body: FutureBuilder<List<TimeEntryModel>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final list = snap.data ?? [];
          if (list.isEmpty)
            return const Center(child: Text('No entries today'));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final e = list[i];
              final fmt = DateFormat('hh:mm a');
              return ExpansionTile(
                title: Text(e.title),
                subtitle: Text('${fmt.format(e.start)} — ${fmt.format(e.end)}'),
                children: [
                  ListTile(
                    title: Text('Duration: ${_formatDuration(e.duration)}'),
                  ),
                  ListTile(title: Text('Description: ${e.description}')),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h}h ${m}m ${s}s';
  }
}
