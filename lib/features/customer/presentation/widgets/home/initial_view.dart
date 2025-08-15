import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class InitialView extends StatelessWidget {
  final String username;
  final VoidCallback onTap;

  const InitialView({super.key, required this.username, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome, $username!",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Image.asset('assets/truck.png', height: 120),
                const Text("Book and Track",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50)),
            child: const Text("Tankers Within State"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50)),
            child: const Text("Tankers With All India Permit"),
          ),
        ],
      ),
    );
  }
}
