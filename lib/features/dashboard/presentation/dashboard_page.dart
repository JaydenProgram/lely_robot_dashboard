import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/add_activity_sheet.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/dashboard_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
        listener: (context, state) {
          if (state.hasError) {
            SnackBar snackBar = SnackBar(content: Text(state.error!));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state.hasData) {
            return Stack(
              children: [
                Column(children: [DashboardChart(data: state.data!)]),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator()),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.red[900],
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    child: Text("+"),

                    onPressed: () {
                      final dashboardCubit = context.read<DashboardCubit>();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return BlocProvider.value(
                            value: dashboardCubit,
                            child: AddActivitySheet(data: state.data!),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state.hasError) {
            return Center(child: Text(state.error.toString()));
          }
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}
