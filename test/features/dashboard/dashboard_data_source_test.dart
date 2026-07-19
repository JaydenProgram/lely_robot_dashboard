import 'package:flutter_test/flutter_test.dart';
import 'package:lely_robot_dashboard/features/dashboard/data/dashboard_data_source.dart';

void main() {
  late DashboardDataSource dataSource;

  setUp(() {
    dataSource = DashboardDataSource();
  });

  group("DashboardDataSource Tests", () {
    test("fetchCollectorData should return a list of records", () async {
      final result = await dataSource.fetchCollectorData();

      expect(result, isNotEmpty);
      expect(result.first.containsKey("date"), isTrue);
    });

    test("saveNewRecord should throw exception for duplicate dates", () async {
      const duplicateDate = "08/10/2025";

      expect(
        () => dataSource.saveNewRecord(duplicateDate, "100"),
        throwsException,
      );
    });
  });
}
