import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lely_robot_dashboard/core/di/injection.dart';
import 'package:lely_robot_dashboard/features/auth/presentation/auth_page.dart';
import 'package:lely_robot_dashboard/features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.red[900]),
      home: BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: const AuthPage(),
      ),
    );
  }
}
