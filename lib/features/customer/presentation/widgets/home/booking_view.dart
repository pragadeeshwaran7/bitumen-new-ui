import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import 'summary_row.dart';

class BookingView extends StatelessWidget {
  final String selectedTanker;
  final String selectedGoods;
  final int loadingQty;
  final int unloadingQty;
  final TextEditingController pickupController;
  final TextEditingController dropController;
  final TextEditingController receiverNameController;
  final TextEditingController receiverPhoneController;
  final TextEditingController receiverEmailController;
  final Map<String, Map<String, dynamic>> trucks;
  final List<String> goodsOptions;
  final int ratePerKm;
  final int totalDistance;
  final int Function() calculateTotal;
  final int Function() calculateAdvance;
  final void Function(String type, int val) onQtyChange;
  final void Function(String val) onTankerChange;
  final void Function(String val) onGoodsChange;
  final VoidCallback onProceed;

  const BookingView({
    super.key,
    required this.selectedTanker,
    required this.selectedGoods,
    required this.loadingQty,
    required this.unloadingQty,
    required this.pickupController,
    required this.dropController,
    required this.receiverNameController,
    required this.receiverPhoneController,
    required this.receiverEmailController,
    required this.trucks,
    required this.goodsOptions,
    required this.ratePerKm,
    required this.totalDistance,
    required this.calculateTotal,
    required this.calculateAdvance,
    required this.onQtyChange,
    required this.onTankerChange,
    required this.onGoodsChange,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Truck Type",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...trucks.entries.map((entry) {
            final isSelected = selectedTanker == entry.key;
            return GestureDetector(
              onTap: () => onTankerChange(entry.key),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red.shade50 : AppColors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primaryRed : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping, color: AppColors.primaryRed),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Capacity: ${entry.value['capacity']}",
                            style: const TextStyle(fontSize: 12, color: AppColors.greyText),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "₹${entry.value['rate']}/km",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),

          buildTextField("Pickup Location", pickupController),
          buildTextField("Drop Location", dropController),
          buildTextField("Receiver Name", receiverNameController),
          buildTextField("Receiver Phone", receiverPhoneController),
          buildTextField("Receiver Email", receiverEmailController),

          const SizedBox(height: 16),
          const Text("Select Goods Type", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goodsOptions.map((option) {
              final isSelected = selectedGoods == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                selectedColor: AppColors.primaryRed,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
                onSelected: (_) => onGoodsChange(option),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Text("Quantity at Loading"),
          quantityRow(loadingQty, (newQty) => onQtyChange("loading", newQty)),
          const SizedBox(height: 12),
          const Text("Quantity at Unloading"),
          quantityRow(unloadingQty, (newQty) => onQtyChange("unloading", newQty)),

          const SizedBox(height: 16),
          SummaryRow(
            ratePerKm: ratePerKm,
            totalDistance: totalDistance,
            total: calculateTotal(),
            advance: calculateAdvance(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onProceed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Make Payment"),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget quantityRow(int value, Function(int) onQtyChange) {
    return Row(
      children: [
        IconButton(
          onPressed: value > 1 ? () => onQtyChange(value -1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          "$value Tons",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => onQtyChange(value + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
