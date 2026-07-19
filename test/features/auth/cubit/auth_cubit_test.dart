import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lely_robot_dashboard/features/auth/data/auth_data_source.dart';
import 'package:lely_robot_dashboard/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  late AuthCubit authCubit;
  late MockAuthDataSource mockAuthDataSource;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    authCubit = AuthCubit(mockAuthDataSource);
  });

  tearDown(() {
    authCubit.close();
  });

  group("AuthCubit tests", () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, data] when login succeeds.',
      setUp: () {
        when(
          () => mockAuthDataSource.login("Lely", "LelyControl2"),
        ).thenAnswer((_) async => {});
      },
      build: () => authCubit,

      act: (cubit) => cubit.login("Lely", "LelyControl2"),

      expect: () => [
        isA<AuthState>()
            .having((state) => state.isLoading, "isLoading", true)
            .having((state) => state.hasData, "hasData", false)
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.error, "error", null),

        isA<AuthState>()
            .having((state) => state.isLoading, "isLoading", false)
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.hasData, "hasData", true)
            .having((state) => state.error, "error", null),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, error] when login fails.',
      build: () => authCubit,
      setUp: () {
        when(
          () => mockAuthDataSource.login("WrongUsername", "WrongPassword"),
        ).thenThrow(Exception("Wrong username or password"));
      },
      act: (cubit) => cubit.login("WrongUsername", "WrongPassword"),
      expect: () => [
        isA<AuthState>()
            .having((state) => state.isLoading, "isLoading", true)
            .having((state) => state.hasError, "hasError", false)
            .having((state) => state.hasData, "hasData", false)
            .having((state) => state.error, "error", null),

        isA<AuthState>()
            .having((state) => state.isLoading, "isLoading", false)
            .having((state) => state.hasError, "hasError", true)
            .having((state) => state.hasData, "hasData", false)
            .having(
              (state) => state.error,
              "error",
              "Exception: Wrong username or password",
            ),
      ],
    );
  });
}
