class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication error']);
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);
  @override
  String toString() => message;
}

class UnknownException implements Exception {
  final String message;
  UnknownException([this.message = 'Unknown error']);
  @override
  String toString() => message;
}
