import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class TankerCard extends StatelessWidget {
  final Map<String, dynamic> tanker;
  final String selectedTab;
  final VoidCallback onAssignDriver;
  final VoidCallback onEnable;
  final VoidCallback onDisable;

  const TankerCard({
    super.key,
    required this.tanker,
    required this.selectedTab,
    required this.onAssignDriver,
    required this.onEnable,
    required this.onDisable,
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
          _header(),
          const SizedBox(height: 8),
          _buildRow("Tanker Type", tanker['type']),
          _buildRow("Max Qty", tanker['maxQty']),
          _buildRow("Allowed Qty", tanker['allowedQty']),
          const Divider(),
          _buildRow("RC No", tanker['rcNo']),
          _buildRow("RC Expiry", tanker['rcExpiry']),
          _buildRow("Insurance No", tanker['insuranceNo']),
          _buildRow("Insurance Expiry", tanker['insuranceExpiry']),
          const Divider(),
          if (selectedTab == "Available Tankers") _availableControls(),
          if (selectedTab == "Disabled Tankers") _disabledControls(),
          if (selectedTab == "Active Tankers") _activeControls(),
        ],
      ),
    );
  }

  Widget _header() {
    Color badgeColor = Colors.grey.shade300;
    Color textColor = Colors.black54;

    if (tanker['status'] == 'Available') {
      badgeColor = Colors.green.shade100;
      textColor = AppColors.green;
    } else if (tanker['status'] == 'In Transit') {
      badgeColor = Colors.orange.shade100;
      textColor = AppColors.orange;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(tanker['tankerNo'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(16)),
          child: Text(tanker['status'], style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _availableControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: onDisable,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700], foregroundColor: AppColors.white),
          child: const Text("Disable"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: tanker['driverAssigned'] ? null : onAssignDriver,
          style: ElevatedButton.styleFrom(
            backgroundColor: tanker['driverAssigned'] ? AppColors.greyText : AppColors.primaryRed,
            foregroundColor: AppColors.white,
          ),
          child: const Text("Assign Driver"),
        ),
      ],
    );
  }

  Widget _disabledControls() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: onEnable,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, foregroundColor: AppColors.white),
        child: const Text("Enable"),
      ),
    );
  }

  Widget _activeControls() {
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tanker['driverName'], style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(tanker['driverPhone']),
            ]),
            IconButton(
              icon: const Icon(Icons.call, color: AppColors.primaryRed),
              onPressed: () {}, // Call logic placeholder
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(color: Colors.black54))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
