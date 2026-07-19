import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:lely_robot_dashboard/features/dashboard/data/dashboard_data_source.dart';

class MockDashboardDataSource extends Mock implements DashboardDataSource {}

void main() {
  late DashboardCubit dashboardCubit;
  late MockDashboardDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockDashboardDataSource();
    dashboardCubit = DashboardCubit(mockDataSource);
  });

  tearDown(() {
    dashboardCubit.close();
  });

  group("DashboardCubit Tests", () {
    blocTest<DashboardCubit, DashboardState>(
      "emits [loading, data] when loadDashboardData succeeds",

      setUp: () {
        when(() => mockDataSource.fetchCollectorData()).thenAnswer(
          (_) async => [
            {"date": "01/01/2026", "duration": "60 min"},
          ],
        );
      },

      build: () => dashboardCubit,

      act: (cubit) => cubit.loadDashboardData(),

      expect: () => [
        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", true)
            .having((state) => state.hasData, "hasData", false),

        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", false)
            .having((state) => state.hasData, "hasData", true)
            .having((state) => state.data!.length, "data length", 1),
      ],
    );
  });
}
