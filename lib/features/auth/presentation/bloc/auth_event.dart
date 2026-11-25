import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequest extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequest({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequest extends AuthEvent {
  final String email;
  final String password;

  const AuthRegisterRequest({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequest extends AuthEvent {
  const AuthLogoutRequest();
}

class AuthCheckRequest extends AuthEvent {
  const AuthCheckRequest();
}
