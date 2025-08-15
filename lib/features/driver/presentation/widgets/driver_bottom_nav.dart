import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class DriverBottomNav extends StatelessWidget {
  final int selectedIndex;

  const DriverBottomNav({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex, // ✅ Highlight the active tab
      selectedItemColor: AppColors.primaryRed,
      unselectedItemColor: AppColors.greyText,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == selectedIndex) return; // Prevent re-navigation
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/driver-home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/driver-orders');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Orders'),
      ],
    );
  }
}
