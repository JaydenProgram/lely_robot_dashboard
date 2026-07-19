import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lely_robot_dashboard/features/auth/presentation/auth_page.dart';
import 'package:lely_robot_dashboard/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();

    when(() => mockAuthCubit.state).thenReturn(
      AuthState(isLoading: false, hasError: false, hasData: false, error: null),
    );
  });

  tearDown(() {
    mockAuthCubit.close();
  });

  testWidgets(
    "AuthPage renders username field, password field, and login button",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: const AuthPage(),
          ),
        ),
      );
      final loginWidgets = find.text('Login');
      final textFields = find.byType(TextFormField);

      expect(loginWidgets, findsNWidgets(2));
      expect(textFields, findsNWidgets(2));
    },
  );

  testWidgets(
    "Test for unallowed characters in username and empty password field",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: const AuthPage(),
          ),
        ),
      );

      final usernameField = find.widgetWithText(TextFormField, "Username");
      final loginButton = find.widgetWithText(ElevatedButton, "Login");

      await tester.enterText(usernameField, "Lely@!@*");

      await tester.tap(loginButton);

      await tester.pumpAndSettle();

      expect(find.text("Special characters are not allowed"), findsOneWidget);
      expect(find.text("Please Enter Your Password"), findsOneWidget);
    },
  );

  testWidgets("Successful login by user", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: const AuthPage(),
        ),
      ),
    );

    final usernameField = find.widgetWithText(TextFormField, "Username");
    final passwordField = find.widgetWithText(TextFormField, "Password");
    final loginButton = find.widgetWithText(ElevatedButton, "Login");

    await tester.enterText(usernameField, "Lely");
    await tester.enterText(passwordField, "LelyControl2");

    await tester.tap(loginButton);

    await tester.pump();

    verify(() => mockAuthCubit.login("Lely", "LelyControl2")).called(1);
  });
}
