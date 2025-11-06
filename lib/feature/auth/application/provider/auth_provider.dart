import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/error_exception.dart';

enum AuthState { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final StreamController<AuthState> _controller;

  AuthProvider() {
    _controller = StreamController<AuthState>.broadcast();
    _auth.authStateChanges().listen((user) {
      _controller.add(
        user == null ? AuthState.unauthenticated : AuthState.authenticated,
      );
      notifyListeners();
    });
  }

  Stream<AuthState> get authState => _controller.stream;

  String? get userId => _auth.currentUser?.uid;

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw UnknownException('Failed to sign out: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  void dispose() {
    _controller.close();
    super.dispose();
  }
}
