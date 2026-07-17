import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/cubit/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lely Robot Dashboard'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isLoading) {
            return const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            );
          }
          if (state.hasError) {
            return Center(child: Text(state.error.toString()));
          }
          if (state.hasData) {
            final chartSpots = generateSpots(state.data!);
            return Center(
              child: LineChart(
                LineChartData(
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
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}
