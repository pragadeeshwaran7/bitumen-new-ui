import 'package:flutter/material.dart';

class TruckInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const TruckInputField(this.label, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
