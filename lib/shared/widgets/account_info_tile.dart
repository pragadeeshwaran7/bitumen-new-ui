import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class AccountInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const AccountInfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryRed),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
