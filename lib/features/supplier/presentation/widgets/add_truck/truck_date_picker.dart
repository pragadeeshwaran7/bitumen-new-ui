import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TruckDatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const TruckDatePicker({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            date != null ? DateFormat.yMMMd().format(date!) : 'Select Date',
          ),
        ),
      ),
    );
  }
}
