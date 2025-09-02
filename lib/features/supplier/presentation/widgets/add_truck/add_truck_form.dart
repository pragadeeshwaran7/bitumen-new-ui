//import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import 'package:mobile_app/features/supplier/controllers/add_truck_controller.dart';
import 'truck_date_picker.dart';
import 'truck_file_upload.dart';
import 'truck_input_field.dart';

class AddTruckForm extends StatefulWidget {
  const AddTruckForm({super.key});

  @override
  State<AddTruckForm> createState() => _AddTruckFormState();
}

class _AddTruckFormState extends State<AddTruckForm> {
  final controller = AddTruckController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Add New Tanker",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        TruckInputField("Tanker Number", controller.tankerNumberController),
        TruckInputField("Tanker Type", controller.tankerTypeController),
        TruckInputField("Maximum Capacity", controller.maxCapacityController),
        TruckInputField("RC Number", controller.rcNumberController),

        TruckDatePicker(
          label: "RC Expiry Date",
          date: controller.rcExpiryDate,
          onTap: () async {
            final picked = await controller.pickDate(context);
            setState(() => controller.rcExpiryDate = picked);
          },
        ),
        TruckFileUpload(
          label: "Upload RC Document",
          file: controller.rcFile,
          onPressed: () async {
            final file = await controller.pickFile();
            setState(() => controller.rcFile = file);
          },
        ),

        TruckInputField("Insurance Number", controller.insuranceNumberController),
        TruckDatePicker(
          label: "Insurance Expiry Date",
          date: controller.insuranceExpiryDate,
          onTap: () async {
            final picked = await controller.pickDate(context);
            setState(() => controller.insuranceExpiryDate = picked);
          },
        ),
        TruckFileUpload(
          label: "Upload Insurance Document",
          file: controller.insuranceFile,
          onPressed: () async {
            final file = await controller.pickFile();
            setState(() => controller.insuranceFile = file);
          },
        ),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => controller.addTanker(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Add Tanker"),
        ),
        const SizedBox(height: 30),
        const Text(
          'By continuing, you agree to our Terms & Conditions and Privacy Policy',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.greyText),
        ),
      ],
    );
  }
}
