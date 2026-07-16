import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lely_robot_dashboard/features/auth/data/auth_data_source.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthDataSource authDataSource;
  AuthCubit(this.authDataSource)
    : super(AuthState(hasData: false, hasError: false, isLoading: false));

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      emit(state.copyWith(true, false, false, null));
      await authDataSource.login(
        usernameController.text,
        passwordController.text,
      );
      emit(state.copyWith(false, false, true, null));
    } on Exception catch (e) {
      emit(state.copyWith(false, true, false, e.toString()));
    }
  }
}
