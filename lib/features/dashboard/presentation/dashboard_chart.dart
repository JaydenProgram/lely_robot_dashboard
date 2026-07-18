import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  final List<Map<String, String>> data;

  const DashboardChart({super.key, required this.data});

  double convertToHours(double minutes) {
    return minutes / 60;
  }

  List<FlSpot> generateSpots(List<Map<String, String>> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      String rawDuration = data[i]["duration"] ?? "0 min";

      double durationInMinutes =
          double.tryParse(rawDuration.replaceAll(' min', '').trim()) ?? 0.0;

      double durationInHours = convertToHours(durationInMinutes);

      spots.add(
        FlSpot(i.toDouble(), double.parse(durationInHours.toStringAsFixed(2))),
      );
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final chartSpots = generateSpots(data);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (double _) =>
                FlLine(color: Colors.white.withAlpha(100), strokeWidth: 1),
            getDrawingVerticalLine: (double _) =>
                FlLine(color: Colors.white.withAlpha(155), strokeWidth: 1),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: chartSpots,
              color: Colors.red[900],
              belowBarData: BarAreaData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
