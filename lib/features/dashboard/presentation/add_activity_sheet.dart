

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/date_input_widget.dart';

class AddActivitySheet extends StatefulWidget {
  final List<Map<String, String>> data;

  const AddActivitySheet({super.key, required this.data});

  @override
  State<AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends State<AddActivitySheet> {
  final TextEditingController minutesController = TextEditingController();
  String? selectedDate;

  @override
  void dispose() {
    minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Add Robot Activity Record',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          const Text(
            'Date',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          
          SizedBox(
            height: 40,
            child: DateInputWidget(
              data: widget.data,
              onDateSelected: (date) {
                // Save the date when picked
                selectedDate = date;
              },
            ),
          ),
          
          const SizedBox(height: 20),

          TextField(
            controller: minutesController, // Bind the controller
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Value in Minutes',
              labelStyle: TextStyle(color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[900],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Ensure both inputs have data
              if (selectedDate != null && minutesController.text.isNotEmpty) {
                // Call the Cubit to save the record
                context.read<DashboardCubit>().addDashboardRecord(
                      selectedDate!,
                      minutesController.text,
                    );
                // Close the bottom sheet
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a date and enter minutes')),
                );
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}