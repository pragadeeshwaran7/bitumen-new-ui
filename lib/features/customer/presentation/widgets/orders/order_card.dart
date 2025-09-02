import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // Removed unused import
import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/models/order_model.dart'; // Updated import

class OrderCard extends StatelessWidget {
  final OrderModel order; // Changed type

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (order.status) {
      case 'in_transit': // Changed status
        statusColor = AppColors.primaryRed;
        break;
      case 'pending': // Changed status
        statusColor = AppColors.orange;
        break;
      case 'delivered': // Changed status
        statusColor = AppColors.green;
        break;
      default:
        statusColor = AppColors.greyText; // Default color for unknown status
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
          _headerRow(order.id!, order.status!, statusColor), // Reverted to !
          const SizedBox(height: 8),
          _infoRow("Date", order.pickupDate.toLocal().toString().split(" ")[0]), // Updated date
          const SizedBox(height: 12),
          _locationRow(order.pickupLocation, order.dropLocation), // Updated locations
          const SizedBox(height: 12),
          _goodsRow(order.goodsType!, order.totalAmount!.toStringAsFixed(0)), // Reverted to !
          const SizedBox(height: 10),
          // Removed _billRow as billurl is not in OrderModel
          // Removed _driverRow as driverName and driverPhone are not in OrderModel
        ],
      ),
    );
  }

  Widget _headerRow(String orderId, String status, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _infoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _locationRow(String pickup, String delivery) {
    return Row(
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
            Text(pickup),
            const SizedBox(height: 20),
            const Text("Delivery", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(delivery),
          ],
        ),
      ],
    );
  }

  Widget _goodsRow(String goods, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(goods, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
      ],
    );
  }
}