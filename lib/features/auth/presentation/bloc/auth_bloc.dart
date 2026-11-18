import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app/features/auth/data/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthInitial()) {
    on<AuthCheckRequest>(_onCheck);
    on<AuthLoginRequest>(_onLogin);
    on<AuthRegisterRequest>(_onRegister);
    on<AuthLogoutRequest>(_onLogout);
  }

  Future<void> _onCheck(AuthCheckRequest event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      final user = await authRepository.getCurrentUser();

      if (user == null) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(_readableError(e)));
    }
  }

  Future<void> _onLogin(AuthLoginRequest event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      final user = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_readableError(e)));
    }
  }

  Future<void> _onRegister(
    AuthRegisterRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await authRepository.register(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_readableError(e)));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await authRepository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(_readableError(e)));
    }
  }
}

String _readableError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'user-not-found':
        return 'No user found for that email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email address.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return error.message ?? error.code;
    }
  } else if (error is FirebaseException) {
    return error.message ?? error.code;
  }

  return error
      .toString()
      .replaceFirst('Exception: ', '')
      .replaceFirst('Exception :', '')
      .trim();
}
