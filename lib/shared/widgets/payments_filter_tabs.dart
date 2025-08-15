import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class PaymentsFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const PaymentsFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  Widget _buildFilterButton(String label) {
    final isSelected = selectedFilter == label;
    Icon icon;
    switch (label) {
      case 'Completed': icon = const Icon(Icons.check_circle_outline, size: 16); break;
      case 'Pending': icon = const Icon(Icons.schedule, size: 16); break;
      default: icon = const Icon(Icons.receipt_long, size: 16); break;
    }

    return GestureDetector(
      onTap: () => onFilterSelected(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['All', 'Completed', 'Pending']
          .map((label) => _buildFilterButton(label))
          .toList(),
    );
  }
}
