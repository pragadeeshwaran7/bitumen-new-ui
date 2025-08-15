import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/driver_home_order.dart';

class DriverOrderCard extends StatelessWidget {
  final DriverHomeOrder order;
  final void Function(String orderId) onAccept;

  const DriverOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order.orderId}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      order.status == 'Pending'
                          ? Colors.orange.shade100
                          : order.status == 'In Transit'
                          ? Colors.red.shade100
                          : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color:
                        order.status == 'Pending'
                            ? AppColors.orange
                            : order.status == 'In Transit'
                            ? AppColors.primaryRed
                            : AppColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(order.date, style: const TextStyle(color: AppColors.greyText)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.circle, size: 10, color: AppColors.primaryRed),
              const SizedBox(width: 6),
              Expanded(child: Text(order.pickup)),
              const Icon(Icons.arrow_forward),
              const SizedBox(width: 6),
              const Icon(Icons.circle, size: 10, color: Colors.yellow),
              const SizedBox(width: 6),
              Expanded(child: Text(order.drop)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildLabelValue("Bitumen", order.bitumen),
              buildLabelValue("Quantity", order.quantity),
              buildLabelValue("Distance", order.distance),
            ],
          ),
          const SizedBox(height: 16),
          if (order.status == 'Pending')
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => onAccept(order.orderId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size(130, 40),
                ),
                child: const Text("Accept Order"),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.greyText),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
