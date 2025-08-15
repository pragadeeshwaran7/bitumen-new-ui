import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/supplier_order.dart';

class SupplierOrderCard extends StatelessWidget {
  final SupplierOrder order;

  const SupplierOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (order.status) {
      case 'In Transit':
        statusColor = AppColors.primaryRed;
        break;
      case 'Pending':
        statusColor = AppColors.orange;
        break;
      default:
        statusColor = AppColors.green;
    }

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
          // Order ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Date", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(order.date, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),

          // Pickup and Delivery
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                children: [
                  Icon(Icons.circle, color: AppColors.primaryRed, size: 10),
                  SizedBox(height: 30),
                  Icon(Icons.circle_outlined, color: AppColors.primaryRed, size: 10),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pickup", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(order.pickup),
                  const SizedBox(height: 20),
                  const Text("Delivery", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(order.delivery),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Truck No and Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.truckNo, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(order.amount, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
            ],
          ),
          const SizedBox(height: 10),

          // Driver Info and Call Button
          if(order.status != 'Completed')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Driver: ${order.driverName}", style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text("Phone: ${order.driverPhone}", style: const TextStyle(color: AppColors.greyText)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final Uri phoneUri = Uri(scheme: 'tel', path: order.driverPhone);
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    throw 'Could not launch $phoneUri';
                  }
                },
                icon: const Icon(Icons.call),
                label: const Text("Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
