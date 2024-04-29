import 'package:appwrite/models.dart';

class Failure {
  String message;
  StackTrace stackTrace;
  Failure(this.message, this.stackTrace);
}

class UserResponse {
  final User? user;
  final String errorMessage;

  const UserResponse({
    required this.user,
    this.errorMessage = '',
  });
}
