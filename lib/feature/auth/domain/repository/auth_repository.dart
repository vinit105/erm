abstract class IAuthRepository {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  String? getCurrentUserId();
}
