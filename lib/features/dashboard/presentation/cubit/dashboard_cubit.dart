import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
      emit(state.copyWith(true, false, false, null)); //loading
      dashboardDataSource.fetchCollectorData();
    } on Exception catch (e) {
      emit(state.copyWith(false, true, false, e.toString())); //error
    }
  }
}
