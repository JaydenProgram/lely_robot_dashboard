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
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.hasData, "hasData", false)
            .having((state) => state.data!.length, "data length", 0)
            .having((state) => state.error, "error", null),

        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", false)
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.hasData, "hasData", true)
            .having((state) => state.data!.length, "data length", 1)
            .having((state) => state.error, "error", null),
      ],
    );
    blocTest<DashboardCubit, DashboardState>(
      "emits [loading, error] when loadDashboardData fails",

      setUp: () {
        when(
          () => mockDataSource.fetchCollectorData(),
        ).thenThrow(Exception("Could not fetch data"));
      },

      build: () => dashboardCubit,

      act: (cubit) => cubit.loadDashboardData(),

      expect: () => [
        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", true)
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.hasData, "hasData", false)
            .having((state) => state.data!.length, "data length", 0)
            .having((state) => state.error, "error", null),

        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", false)
            .having((state) => state.hasError, "hasError", true)
            .having((state) => state.hasData, "hasData", false)
            .having((state) => state.data!.length, "data length", 0)
            .having(
              (state) => state.error,
              "error",
              "Exception: Could not fetch data",
            ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emits [loading, data] when addDashboardRecord succeeds.',
      seed: () => DashboardState(
        isLoading: false,
        hasError: false,
        hasData: true,
        data: const [
          {"date": "18/07/2026", "duration": "100"},
        ],
      ),
      setUp: () {
        when(
          () => mockDataSource.saveNewRecord("19/07/2026", "64"),
        ).thenAnswer((_) async => {});

        when(() => mockDataSource.fetchCollectorData()).thenAnswer(
          (_) async => [
            {"date": "18/07/2026", "duration": "100"},
            {"date": "19/07/2026", "duration": "64"},
          ],
        );
      },
      build: () => dashboardCubit,
      act: (cubit) => cubit.addDashboardRecord("19/07/2026", "64"),
      expect: () => [
        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", true)
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.hasData, "hasData", true)
            .having((state) => state.data!.length, "data length", 1)
            .having((state) => state.error, "error", null),

        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", false)
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.hasData, "hasData", true)
            .having((state) => state.data!.length, "data length", 2)
            .having((state) => state.error, "error", null),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emits [loading, error] when addDashboardRecord fails.',
      seed: () => DashboardState(
        isLoading: false,
        hasError: false,
        hasData: true,
        data: const [
          {"date": "19/07/2026", "duration": "64"},
        ],
      ),
      setUp: () {
        when(() => mockDataSource.saveNewRecord("19/07/2026", "64")).thenThrow(
          Exception(
            "Duplicate dates are not allowed. Please select a different date.",
          ),
        );

        when(
          () => mockDataSource.fetchCollectorData(),
        ).thenAnswer((_) async => []);
      },
      build: () => dashboardCubit,
      act: (cubit) => cubit.addDashboardRecord("19/07/2026", "64"),
      expect: () => [
        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", true)
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.hasData, "hasData", true)
            .having((state) => state.data!.length, "data length", 1)
            .having((state) => state.error, "error", null),

        isA<DashboardState>()
            .having((state) => state.isLoading, "isLoading", false)
            .having((state) => state.hasError, "hasError", true)
            .having((state) => state.hasData, "hasData", true)
            .having((state) => state.data!.length, "data length", 1)
            .having(
              (state) => state.error,
              "error",
              "Exception: Duplicate dates are not allowed. Please select a different date.",
            ),
      ],
    );
  });
}
