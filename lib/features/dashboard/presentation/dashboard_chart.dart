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
    final int maxItems = 5;
    final List<Map<String, String>> recentData = data.length > maxItems
        ? data.sublist(data.length - maxItems)
        : data;
    final chartSpots = generateSpots(recentData);
    final lineColor = Colors.red.shade900;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height / 2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1.0,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.withAlpha(76), strokeWidth: 1),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade400, width: 1),
              left: BorderSide(color: Colors.grey.shade400, width: 1),
              right: BorderSide.none,
              top: BorderSide.none,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'DATES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              axisNameSize: 30,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    String dateStr = data[index]["date"] ?? "";
                    List<String> parts = dateStr.split('/');
                    String formattedDate = dateStr;
                    if (parts.length >= 3) {
                      formattedDate = '${parts[0]}/${parts[1]}/\n${parts[2]}';
                    }
                    return Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                'HOURS / DAY (Calculated from Min)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              axisNameSize: 24,
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1.0,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: chartSpots,
              isCurved: true,
              color: lineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: lineColor,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [lineColor.withAlpha(127), lineColor.withAlpha(10)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
