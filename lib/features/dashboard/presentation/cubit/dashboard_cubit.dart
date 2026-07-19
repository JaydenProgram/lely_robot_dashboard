import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lely_robot_dashboard/features/dashboard/data/dashboard_data_source.dart';

part 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final DashboardDataSource dashboardDataSource;
  DashboardCubit(this.dashboardDataSource)
    : super(DashboardState(isLoading: false, hasError: false, hasData: false));

  void loadDashboardData() async {
    try {
      emit(state.copyWith(true, false, false, [], null)); //loading
      final result = await dashboardDataSource.fetchCollectorData();
      emit(state.copyWith(false, false, true, result, null)); //data passed
    } on Exception catch (e) {
      emit(state.copyWith(false, true, false, [], e.toString())); //error
    }
  }

  void addDashboardRecord(String date, String durationInMinutes) async {
    try {
      emit(state.copyWith(true, false, false, state.data, null));
      await Future.delayed(const Duration(seconds: 1));
      await dashboardDataSource.saveNewRecord(date, durationInMinutes);
      final updatedData = await dashboardDataSource.fetchCollectorData();
      emit(state.copyWith(false, false, true, updatedData, null));
    } on Exception catch (e) {
      emit(state.copyWith(false, true, true, state.data, e.toString()));
    }
  }
}
