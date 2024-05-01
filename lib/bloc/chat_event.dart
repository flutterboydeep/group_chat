// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class SignUpEvent extends ChatEvent {
  final String username;
  final String email;
  final String password;
  SignUpEvent({
    required this.username,
    required this.email,
    required this.password,
  });
}

class LoginEvent extends ChatEvent {
  final String password;
  final String email;

  LoginEvent({
    required this.password,
    required this.email,
  });
}

class SharedPrefEvent extends ChatEvent {
  final bool isLogin;

  SharedPrefEvent({required this.isLogin});
}

class LogoutEvent extends ChatEvent {}
