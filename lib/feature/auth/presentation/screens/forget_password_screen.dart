import 'package:erm/shared/widgets/custom_button_widget.dart';
import 'package:erm/shared/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../application/provider/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>(); // ✅ Added global form key

  Future<void> _sendReset(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // ❌ Stop if invalid
      return;
    }
    setState(() {
      _loading = true;
    });
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      await auth.sendPasswordResetEmail(_emailCtrl.text.trim());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent successfully'),
          ),
        );
        Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey, // ✅ Attach form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your registered email to receive a password reset link.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // ✅ Email field with validator
              CustomTextField(
                controller: _emailCtrl,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ✅ Send Reset Button
              CustomButton(
                onPressed: () => _sendReset(context),
                text: "Send Reset Link",
                isLoading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
