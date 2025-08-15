import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class OrdersFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const OrdersFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'In Transit', 'Pending', 'Completed'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: filters.map((label) {
        final isSelected = selectedFilter == label;
        return GestureDetector(
          onTap: () => onFilterSelected(label),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryRed : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
