import 'package:equatable/equatable.dart';
import 'package:firebase_app/features/domain/app_users.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}
//Success State
class AuthAuthenticated extends AuthState {
  final AppUsers user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}
//Failure State
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
