import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/application/provider/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../application/provider/time_provider.dart';
import 'history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.qr_code_scanner),
          //   onPressed: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const QRScanScreen()),
          //   ),
          // ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Elapsed: ${_formatDuration(timer.elapsed)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            if (!timer.running)
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start'),
                onPressed: () => timer.start(),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                    onPressed: () => timer.pause(),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    onPressed: () => _onStopPressed(context, timer),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  static void _onStopPressed(BuildContext context, TimerProvider timer) {
    final titleCtl = TextEditingController();
    final descCtl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save interval'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descCtl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleCtl.text.trim();
              final desc = descCtl.text.trim();
              if (title.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Title required')));
                return;
              }
              Navigator.of(ctx).pop();
              try {
                await timer.stopAndSave(title: title, description: desc);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Saved')));
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
