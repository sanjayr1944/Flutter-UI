import 'package:firebase_app/features/auth/data/item_repo.dart';
import 'package:firebase_app/features/auth/presentation/bloc/item_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/item_event.dart';
import 'firebase_options.dart';
import 'features/auth/data/auth_repo.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/presentation/login_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/user_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final repo = AuthRepository();
  final itemRepo = ItemRepository();
  runApp(
    MultiBlocProvider(
     providers: [
       BlocProvider(create: (_) => AuthBloc(repo)..add(const AuthCheckRequest())), //Is user already Logged or Not
       BlocProvider(create: (_)=> ItemBloc(itemRepo)..add(const LoadItemsSubscription())),
     ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) {
          if (previous is AuthInitial) return true;
          return current is AuthAuthenticated || current is AuthUnauthenticated;
        },
        builder: (context, state) {
          if (state is AuthInitial || state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is AuthAuthenticated) {
            if (state.user.role == 'admin') {
              return const AdminHomeScreen();
            }
            return const UserHomeScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
