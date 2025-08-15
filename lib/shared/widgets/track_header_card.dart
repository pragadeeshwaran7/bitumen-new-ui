import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/models/tracking.dart';

class TrackHeaderCard extends StatelessWidget {
  final Tracking order;
  final String? mode;
  final Function(String) onViewModeChanged;

  const TrackHeaderCard({
    super.key,
    required this.order,
    required this.mode,
    required this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tracking ID", style: TextStyle(color: AppColors.greyText)),
          Text(order.trackingId,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("Status", style: TextStyle(color: AppColors.greyText)),
                Text(order.status, style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("ETA", style: TextStyle(color: AppColors.greyText)),
                Text(order.eta, style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onViewModeChanged('map'),
                  icon: const Icon(Icons.location_on_outlined),
                  label: const Text('Live View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mode == 'map' ? AppColors.primaryRed : Colors.grey[300],
                    foregroundColor: mode == 'map' ? AppColors.white : AppColors.black,
                    minimumSize: const Size.fromHeight(45),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onViewModeChanged('camera'),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Camera View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        mode == 'camera' ? AppColors.primaryRed : Colors.grey[300],
                    foregroundColor: mode == 'camera' ? AppColors.white : AppColors.black,
                    minimumSize: const Size.fromHeight(45),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}