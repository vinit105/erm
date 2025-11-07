import 'package:erm/feature/dashboard/application/provider/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'feature/auth/application/provider/auth_provider.dart';
import 'feature/auth/presentation/screens/login_screen.dart';
import 'feature/dashboard/presentation/screens/dashboard_screen.dart';
import 'feature/internet_checker/application/internet_checker_provider.dart';
import 'feature/internet_checker/presentation/internet_checker_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider("")),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECS System',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ConnectionWrapper(child: AuthGate()),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return StreamBuilder<AuthState>(
      stream: auth.authState,
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (state == AuthState.authenticated) {
          return const DashboardScreen();
        } else if (state == AuthState.unauthenticated) {
          return const LoginScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
