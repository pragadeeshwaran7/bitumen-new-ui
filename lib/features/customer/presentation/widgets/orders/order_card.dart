import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/customer_order.dart';

class OrderCard extends StatelessWidget {
  final CustomerOrder order;

  const OrderCard({super.key, required this.order});

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
          _headerRow(order.orderId, order.status, statusColor),
          const SizedBox(height: 8),
          _infoRow("Date", order.date.toString().split(" ")[0]),
          const SizedBox(height: 12),
          _locationRow(order.pickup, order.delivery),
          const SizedBox(height: 12),
          _goodsRow(order.goods, order.amount),
          const SizedBox(height: 10),
           _billRow(context, order.billurl),
          const SizedBox(height: 10),
          if (order.status != "Completed") _driverRow(order.driverName ?? "", order.driverPhone ?? ""),
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
            color: statusColor.withOpacity(0.1),
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

  Widget _billRow(BuildContext context, String? billUrl) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () async {
          if (billUrl != null && billUrl.isNotEmpty) {
            final Uri uri = Uri.parse(billUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Could not open bill URL")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Bill not uploaded yet")),
            );
          }
        },
        icon: const Icon(Icons.receipt_long, color: AppColors.primaryRed),
        label: const Text("View Bill", style: TextStyle(color: AppColors.primaryRed)),
      ),
    );
  }

  Widget _driverRow(String name, String phone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Driver: $name", style: const TextStyle(fontWeight: FontWeight.w500)),
            Text("Phone: $phone", style: const TextStyle(color: AppColors.greyText)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final Uri uri = Uri(scheme: 'tel', path: phone);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              throw 'Could not launch $uri';
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
    );
  }
}
