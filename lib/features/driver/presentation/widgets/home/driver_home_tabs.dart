import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class DriverHomeTabs extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabChange;

  const DriverHomeTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ['New Orders', 'Active', 'Completed'].map((tab) {
          final isSelected = selectedTab == tab;
          return GestureDetector(
            onTap: () => onTabChange(tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected ? AppColors.primaryRed : Colors.grey[200],
              ),
              child: Text(
                tab,
                style: TextStyle(color: isSelected ? AppColors.white : AppColors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
