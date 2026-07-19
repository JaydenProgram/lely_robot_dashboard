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

  tearDown(authCubit.close());
}
