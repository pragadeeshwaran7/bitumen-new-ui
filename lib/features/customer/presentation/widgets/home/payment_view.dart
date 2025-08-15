import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class PaymentView extends StatelessWidget {
  final int total;
  final int advance;
  final int balance;
  final String selectedMethod;
  final void Function(String method) onMethodChange;
  final VoidCallback onConfirm;

  const PaymentView({
    super.key,
    required this.total,
    required this.advance,
    required this.balance,
    required this.selectedMethod,
    required this.onMethodChange,
    required this.onConfirm, required void Function() onPay,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Confirm Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Price", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text("₹$total", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "75% Advance Payment",
                        style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "₹$advance.00",
                        style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text("Balance on Delivery\n₹$balance.00", style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _buildPaymentOption(
            icon: Icons.credit_card,
            label: "Credit/Debit Card",
            description: "All major cards accepted",
            value: "card",
          ),
          _buildPaymentOption(
            icon: Icons.qr_code,
            label: "UPI Payment",
            description: "Google Pay, PhonePe, Paytm",
            value: "upi",
          ),
          _buildPaymentOption(
            icon: Icons.account_balance,
            label: "Net Banking",
            description: "All major banks supported",
            value: "netbanking",
          ),

          const SizedBox(height: 24),
          const Text("Saved Cards", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.credit_card, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("•••• •••• •••• 4567", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Expires 05/25", style: TextStyle(color: AppColors.greyText)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Default", style: TextStyle(color: AppColors.green)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Confirm & Pay"),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required String description,
    required String value,
  }) {
    final isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => onMethodChange(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.shade50 : AppColors.white,
          border: Border.all(color: isSelected ? AppColors.primaryRed : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryRed : AppColors.greyText),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(description, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primaryRed : AppColors.greyText,
            ),
          ],
        ),
      ),
    );
  }
}
