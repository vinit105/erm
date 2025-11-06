import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../application/internet_checker_provider.dart';

class ConnectionWrapper extends StatelessWidget {
  final Widget child;
  const ConnectionWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, provider, _) {
        if (!provider.hasConnection) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 60, color: Colors.redAccent),
                  const SizedBox(height: 20),
                  const Text(
                    "No Internet Connection",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => provider
                        .notifyListeners(), // manually refresh (optional)
                    icon: const Icon(Icons.refresh),
                    label: const Text("Try Again"),
                  ),
                ],
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}
