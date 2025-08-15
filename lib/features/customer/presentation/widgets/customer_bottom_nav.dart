import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class CustomerBottomNav extends StatelessWidget {
  final int selectedIndex;

  const CustomerBottomNav({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex, 
      selectedItemColor: AppColors.primaryRed,
      unselectedItemColor: AppColors.greyText,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == selectedIndex) return; 
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/customer-home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/customer-orders');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/customer-payments');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/customer-track');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/customer-account');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Orders"),
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payments"),
        BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: "Track"),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
      ],
    );
  }
}

