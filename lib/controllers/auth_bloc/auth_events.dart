import '../../models/user_model.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

// sign up event
class SignUpRequested extends AuthEvent {
  final UserModel user;

  SignUpRequested({
    required this.user,
  });
}

// log out event
class LogoutRequested extends AuthEvent {}
