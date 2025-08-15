import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class DriverOrderDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DriverOrderDetailRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.greyText)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
