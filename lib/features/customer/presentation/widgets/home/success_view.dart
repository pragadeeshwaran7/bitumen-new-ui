import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/customer_booking.dart';

class SuccessView extends StatelessWidget {
  final CustomerBooking order;
  final VoidCallback onBackToHome;

  const SuccessView({
    super.key,
    required this.order,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: AppColors.green),
            const SizedBox(height: 16),
            const Text(
              "Order Placed Successfully!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Order Summary Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row("Tanker Type", order.tankerType),
                    _row("Goods", order.goods),
                    _row("Pickup", order.pickup),
                    _row("Drop", order.drop),
                    _row("Distance", "${order.distance} km"),
                    _row("Total", "₹${order.totalAmount}"),
                    _row("Advance", "₹${order.advanceAmount}"),
                    _row("Balance", "₹${order.balanceAmount}"),
                    _row("Status", order.status),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onBackToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
