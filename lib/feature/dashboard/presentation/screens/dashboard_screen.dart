import 'package:erm/shared/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/application/provider/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../application/provider/time_provider.dart';
import 'history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const companyName = "XYZ"; //
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🏢 Welcome Card
              Column(
                children: [
                  Text(
                    "Welcome to $companyName 👋",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Track your work time efficiently below.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // ⏱ Timer Display
              Text(
                'Elapsed: ${_formatDuration(timer.elapsed)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // ▶️ Buttons Logic
              if (!timer.running && timer.elapsed == Duration.zero)
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  onPressed: () => timer.start(),
                )
              else if (timer.running)
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
                )
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Resume'),
                  onPressed: () => timer.start(),
                ),
            ],
          ),
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
      builder: (ctx) {
        final formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: const Text('Save Time Entry'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleCtl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Title required' : null,
                ),
                TextFormField(
                  controller: descCtl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description required'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  Provider.of<TimerProvider>(
                    context,
                    listen: false,
                  ).setLoading(true);
                  await timer.stopAndSave(
                    title: titleCtl.text.trim(),
                    description: descCtl.text.trim(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Time entry saved successfully!'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
                } finally {
                  Provider.of<TimerProvider>(
                    context,
                    listen: false,
                  ).setLoading(false);
                  Navigator.of(ctx).pop();
                }
              },
              child: timer.loading
                  ? Transform.scale(
                      scale: 0.7, // 0.5 = half size, 1.0 = normal
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.teal,
                      ),
                    )
                  : Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
