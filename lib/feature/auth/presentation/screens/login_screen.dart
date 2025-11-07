import 'package:erm/feature/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:erm/shared/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/custom_text_field_widget.dart';
import '../../application/provider/auth_provider.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // ✅ Global form key
  bool _loading = false;

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // ❌ Stop if invalid input
      return;
    }

    setState(() {
      _loading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.signIn(
        _emailCtrl.text.trim(),
        _passwordCtrl.text.trim(),
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // ✅ Wrap entire form
              child: Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // ✅ Email Field
                  CustomTextField(
                    controller: _emailCtrl,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // ✅ Password Field
                  CustomTextField(
                    controller: _passwordCtrl,
                    hintText: "Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ✅ Login Button
                  CustomButton(
                    onPressed: () => _login(context),
                    text: "Login",
                    isLoading: _loading,
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    ),
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
