import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/supplier_payment.dart';

class PaymentCard extends StatelessWidget {
  final SupplierPayment payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    Color statusColor = payment.status == 'Pending'
        ? AppColors.orange
        : payment.status == 'Completed'
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.credit_card, color: AppColors.primaryRed, size: 18),
                const SizedBox(width: 6),
                Text(payment.paymentMode,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(payment.status,
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(payment.amount,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
        const SizedBox(height: 4),
        Text(payment.date,
            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(height: 8),
        Text("Order: ${payment.orderId}", style: const TextStyle(fontSize: 13)),
        Text("Receipt: ${payment.receiptId}", style: const TextStyle(fontSize: 13)),
      ]),
    );
  }
}
