import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class TopTabSelector extends StatelessWidget {
  final String selectedTab;
  final Function(String) onSelect;

  const TopTabSelector({super.key, required this.selectedTab, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Available Tankers', 'Active Tankers', 'Disabled Tankers'];

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((tab) {
          final isSelected = selectedTab == tab;
          return GestureDetector(
            onTap: () => onSelect(tab),
            child: Column(
              children: [
                Text(
                  tab.replaceAll(" Tankers", ""),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primaryRed : AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 2,
                  width: 40,
                  color: isSelected ? AppColors.primaryRed : Colors.transparent,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
