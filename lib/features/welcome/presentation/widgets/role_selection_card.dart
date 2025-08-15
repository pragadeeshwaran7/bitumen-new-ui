import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class RoleSelectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryRed,
        side: const BorderSide(color: AppColors.primaryRed),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
