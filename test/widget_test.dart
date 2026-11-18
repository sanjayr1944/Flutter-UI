import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_app/features/presentation/login_screen.dart';
import 'package:firebase_app/features/presentation/signup_screen.dart';
import 'package:firebase_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_app/features/auth/data/auth_repo.dart';
import 'package:firebase_app/features/domain/app_users.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<AppUsers> login({required String email, required String password}) async {
    return AppUsers(uid: '123', email: email, role: 'user');
  }

  @override
  Future<AppUsers> register({required String email, required String password}) async {
    return AppUsers(uid: '123', email: email, role: 'user');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AppUsers?> getCurrentUser() async => null;
}

void main() {
  testWidgets('LoginScreen displays email, password fields and sign in button',
      (WidgetTester tester) async {
    final bloc = AuthBloc(MockAuthRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: bloc,
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);

    bloc.close();
  });

  testWidgets('SignupScreen displays email, password, confirm password fields',
      (WidgetTester tester) async {
    final bloc = AuthBloc(MockAuthRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: bloc,
          child: const SignupScreen(),
        ),
      ),
    );

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    bloc.close();
  });
}
