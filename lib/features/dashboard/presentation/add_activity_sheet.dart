import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/date_input_widget.dart';

class AddActivitySheet extends StatefulWidget {
  final List<Map<String, String>> data;

  const AddActivitySheet({super.key, required this.data});

  @override
  State<AddActivitySheet> createState() => AddActivitySheetState();
}

class AddActivitySheetState extends State<AddActivitySheet> {
  final TextEditingController minutesController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
      child: Form(
        key: formKey,
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            const Text(
              'Date',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            FormField<String>(
              autovalidateMode: .onUserInteraction,
              validator: (value) {
                if (selectedDate == null || selectedDate!.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
              builder: (formFieldState) {
                return InputDecorator(
                  decoration: InputDecoration(
                    errorText: formFieldState.errorText,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  child: SizedBox(
                    height: 40,
                    child: DateInputWidget(
                      data: widget.data,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                        formFieldState.didChange(date);
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              autovalidateMode: .onUserInteraction,
              controller: minutesController,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[^0-9]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a duration";
                }

                return null;
              },
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
                if (!formKey.currentState!.validate()) {
                  return;
                }
                context.read<DashboardCubit>().addDashboardRecord(
                  selectedDate!,
                  minutesController.text,
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
