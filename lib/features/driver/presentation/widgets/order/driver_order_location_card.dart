import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class DriverOrderLocationCard extends StatelessWidget {
  final String title;
  final String location;
  final String address;
  final Color color;
  final bool showOtp;
  final TextEditingController controller;
  final VoidCallback onVerify;
  final bool verified;

  const DriverOrderLocationCard({
    super.key,
    required this.title,
    required this.location,
    required this.address,
    required this.color,
    required this.showOtp,
    required this.controller,
    required this.onVerify,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Icon(Icons.circle, size: 10, color: color),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text(location, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Text(address, style: const TextStyle(color: AppColors.greyText)),
        if (showOtp) ...[
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter OTP",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onVerify,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed, foregroundColor: AppColors.white),
            child: const Text("Verify OTP"),
          )
        ],
        if (verified)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("Verified",
                style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
          )
      ]),
    );
  }
}
