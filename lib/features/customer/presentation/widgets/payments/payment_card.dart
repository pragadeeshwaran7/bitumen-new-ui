import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/models/order_model.dart'; // Updated import

class PaymentCard extends StatelessWidget {
  final OrderModel payment; // Changed type

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    Color statusColor = payment.status == 'pending' // Changed status
        ? AppColors.orange
        : payment.status == 'delivered' // Changed status
            ? AppColors.green
            : AppColors.greyText;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _paymentHeader(payment.paymentMethod!, payment.status!, statusColor), // Updated fields
          const SizedBox(height: 10),
          Text(
            "₹${payment.totalAmount?.toStringAsFixed(0)}", // Updated field
            style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
          ),
          const SizedBox(height: 4),
          Text(payment.createdAt!.toLocal().toString().split(" ")[0], style: TextStyle(color: Colors.grey[600], fontSize: 13)), // Updated field
          const SizedBox(height: 8),
          Text("Order: ${payment.id!}", style: const TextStyle(fontSize: 13)), // Updated field
          // Removed Receipt line
        ],
      ),
    );
  }

  Widget _paymentHeader(String mode, String status, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.credit_card, color: AppColors.primaryRed, size: 18),
            const SizedBox(width: 6),
            Text(mode, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}