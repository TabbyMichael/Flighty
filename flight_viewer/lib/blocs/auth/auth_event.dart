part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;

  LoggedIn({required this.token});
}

class LoggedOut extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({
    required this.email,
    required this.password,
  });
}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String? fullName;

  SignupRequested({
    required this.email,
    required this.password,
    this.fullName,
  });
}

class RefreshTokenRequested extends AuthEvent {}