import 'package:flutter_test/flutter_test.dart';
import 'package:lely_robot_dashboard/features/auth/data/auth_data_source.dart';

void main() {
  late AuthDataSource dataSource;

  setUp(() {
    dataSource = AuthDataSource();
  });

  group("AuthDataSource tests", () {
    test("login completes successfully with correct credentials", () async {
      await expectLater(dataSource.login("Lely", "LelyControl2"), completes);
    });

    test("login should throw exception of credentials are incorrect", () async {
      await expectLater(
        dataSource.login("Wrongname", "WrongPassword"),
        throwsException,
      );
    });
  });
}
