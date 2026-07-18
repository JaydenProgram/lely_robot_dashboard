import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputWidget extends StatefulWidget {
  final List<Map<String, String>> data;
  final ValueChanged<String> onDateSelected;

  const DateInputWidget({
    super.key,
    required this.data,
    required this.onDateSelected,
  });

  @override
  State<DateInputWidget> createState() => _DateInputWidgetState();
}

class _DateInputWidgetState extends State<DateInputWidget> {
  final TextEditingController dateController = TextEditingController();

  Future<void> selectDate() async {
    final DateFormat formatter = DateFormat("dd/MM/yyyy");

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final String formattedDate = formatter.format(picked);
      
      setState(() {
        dateController.text = formattedDate;
      });
      
      widget.onDateSelected(formattedDate);
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: dateController,
      readOnly: true,
      onTap: selectDate,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: "DD/MM/YYYY",
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}