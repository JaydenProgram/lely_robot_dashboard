import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lely_robot_dashboard/features/auth/data/auth_data_source.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthDataSource authDataSource;
  AuthCubit(this.authDataSource)
    : super(AuthState(hasData: false, hasError: false, isLoading: false));

  void login(String username, String password) async {
    try {
      emit(state.copyWith(true, false, false, null)); //loading
      await authDataSource.login(username, password);
      emit(state.copyWith(false, false, true, null)); //data passed
    } on Exception catch (e) {
      emit(state.copyWith(false, true, false, e.toString())); //error
    }
  }
}
