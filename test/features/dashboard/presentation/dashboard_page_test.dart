import 'package:bloc_test/bloc_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/dashboard_page.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}

void main() {
  late MockDashboardCubit mockDashboardCubit;

  setUp(() {
    mockDashboardCubit = MockDashboardCubit();
  });

  tearDown(() {
    mockDashboardCubit.close();
  });

  testWidgets("Dashboardpage shows loading circle when isLoading is true", (
    WidgetTester tester,
  ) async {
    when(() => mockDashboardCubit.state).thenReturn(
      DashboardState(
        isLoading: true,
        hasError: false,
        hasData: false,
        data: [],
        error: null,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DashboardCubit>.value(
          value: mockDashboardCubit,
          child: DashboardPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Dashboardpage shows the graph when data is loaded", (
    WidgetTester tester,
  ) async {
    when(() => mockDashboardCubit.state).thenReturn(
      DashboardState(
        isLoading: false,
        hasError: false,
        hasData: true,
        data: [
          {"date": "10/08/2025", "duration": "100 min"},
        ],
        error: null,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DashboardCubit>.value(
          value: mockDashboardCubit,
          child: DashboardPage(),
        ),
      ),
    );

    expect(find.byType(LineChart), findsOneWidget);
  });

  testWidgets("Dashboardpage shows error message when haserror is true", (
    WidgetTester tester,
  ) async {
    when(() => mockDashboardCubit.state).thenReturn(
      DashboardState(
        isLoading: false,
        hasError: true,
        hasData: false,
        data: [],
        error: "Exception: Failed to load data",
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DashboardCubit>.value(
          value: mockDashboardCubit,
          child: DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Exception: Failed to load data"), findsOneWidget);
  });

  testWidgets(
    "Dashboardpage still shows chart correctly when switching interval amount using buttons",
    (WidgetTester tester) async {
      final List<Map<String, String>> thirtyDayData = List.generate(
        30,
        (index) => {"date": "10/08/2026", "duration": "${index + 10} min"},
      );
      when(() => mockDashboardCubit.state).thenReturn(
        DashboardState(
          isLoading: false,
          hasError: false,
          hasData: true,
          data: thirtyDayData,
          error: null,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DashboardCubit>.value(
            value: mockDashboardCubit,
            child: DashboardPage(),
          ),
        ),
      );

      final fiveButton = find.widgetWithText(ChoiceChip, "5 days");
      final sevenButton = find.widgetWithText(ChoiceChip, "7 days");
      final thirtyButton = find.widgetWithText(ChoiceChip, "30 days");
      final allButton = find.widgetWithText(ChoiceChip, "All");

      await tester.tap(allButton);

      await tester.pumpAndSettle();

      expect(find.byType(LineChart), findsOneWidget);
    },
  );

  testWidgets(
    "Dashboardpage shows bottom sheet modal when plus button is pressed",
    (WidgetTester tester) async {
      when(() => mockDashboardCubit.state).thenReturn(
        DashboardState(
          isLoading: false,
          hasError: false,
          hasData: true,
          data: [
            {"date": "10/08/2025", "duration": "100 min"},
          ],
          error: null,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DashboardCubit>.value(
            value: mockDashboardCubit,
            child: DashboardPage(),
          ),
        ),
      );

      final plusButton = find.widgetWithText(FloatingActionButton, "+");

      await tester.tap(plusButton);

      await tester.pumpAndSettle();

      expect(find.text("Add Robot Activity Record"), findsOneWidget);
    },
  );
}
