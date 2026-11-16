import 'package:firebase_app/bloc/auth_event.dart';
import 'package:firebase_app/features/auth/data/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

//Have to pass the Event and State. AuthEvent and AuthState.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthInitial());

  //LOGIN

  //Emitter - NotifyListners
  Future<void> _onLogin(AuthLoginRequest event, Emitter<AuthState> emit) async {
    //isLoading = true
    //notifyListners
    emit(const AuthLoading());

    try {
      final user = await authRepository.register(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e)
    {
      emit(AuthError(_readableError(e)));
    }
  }

  //LOGOUT
Future<void> _onLogout (AuthLoginRequest event, Emitter<AuthState>emit) async
{
  emit(AuthLoading());

  try{
    await authRepository.logout();
    emit(const AuthUnauthenticated()); //Will go to Login Screen
  }
  catch(e)
  {
    emit(AuthError(_readableError(e)));
  }
}

Future<void> _onCheck(AuthCheckRequest event, Emitter<AuthState> emit) async
{
  emit(const AuthLoading());

  try
  {
    final user = await authRepository.getCurrentUser();

    if(user == null)
    {
      emit(const AuthUnauthenticated()); //Will go to Login Screen

    }
    else
    {
      emit(AuthAuthenticated(user)); //Will go to Home Screen
    }
  }
  catch(e)
  {
    emit(AuthError(_readableError(e)));
  }
}
}


String _readableError(Object error)
{
  return error.toString().replaceFirst("Exception :", "");
}
