import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final int ratePerKm;
  final int totalDistance;
  final int total;
  final int advance;

  const SummaryRow({
    super.key,
    required this.ratePerKm,
    required this.totalDistance,
    required this.total,
    required this.advance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            row("Rate per km", "₹$ratePerKm"),
            row("Total Distance", "$totalDistance km"),
            row("Total Cost", "₹$total"),
            row("Advance (75%)", "₹$advance"),
          ],
        ),
      ),
    );
  }

  Widget row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}
