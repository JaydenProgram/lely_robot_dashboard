import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lely_robot_dashboard/features/auth/data/auth_data_source.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
    : super(AuthState(hasData: false, hasError: false, isLoading: false));

  AuthDataSource authDataSource = AuthDataSource();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void login() async {
    emit(state.copyWith(true, false, true, null));
    try {
      await authDataSource.login(
        usernameController.text,
        passwordController.text,
      );
      emit(state.copyWith(false, false, true, null));
    } catch (e) {
      emit(state.copyWith(false, true, false, e.toString()));
    }
  }
}
