import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/services/driver_home_service.dart';

class DriverHomeHeader extends StatelessWidget {
  final String driverId; // Required for identifying driver

  const DriverHomeHeader({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    final payment = DriverHomeApiService().getPaymentDetails(driverId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Incentive Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.background,
                    radius: 18,
                    child: Icon(Icons.wallet_giftcard, color: AppColors.primaryRed),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("₹${payment.incentive}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      const Text("Incentives", style: TextStyle(fontSize: 12, color: AppColors.greyText)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Distance Covered Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.background,
                    radius: 18,
                    child: Icon(Icons.location_on, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${payment.kmcovered} km", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      const Text("Distance Covered", style: TextStyle(fontSize: 12, color: AppColors.greyText)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
