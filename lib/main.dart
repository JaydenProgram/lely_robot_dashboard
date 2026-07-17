import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lely_robot_dashboard/core/di/injection.dart';
import 'package:lely_robot_dashboard/features/auth/presentation/auth_page.dart';
import 'package:lely_robot_dashboard/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/dashboard_page.dart';

void main() {
  configureDependencies();
  runApp(const MainApp());
}

// main.dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            return BlocListener<AuthCubit, AuthState>(
              listenWhen: (previous, current) =>
                  !previous.hasData && current.hasData,
              listener: (context, state) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) =>
                          getIt<DashboardCubit>()..loadDashboardData(),
                      child: const DashboardPage(),
                    ),
                  ),
                );
              },
              child: const AuthPage(),
            );
          },
        ),
      ),
    );
  }
}
