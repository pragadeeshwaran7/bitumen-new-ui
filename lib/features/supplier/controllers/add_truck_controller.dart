import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/services/tanker_service.dart';
import '../../../shared/models/tanker_model.dart'; // Import TankerModel

class AddTruckController {
  final tankerNumberController = TextEditingController();
  final tankerTypeController = TextEditingController();
  final maxCapacityController = TextEditingController();
  final rcNumberController = TextEditingController();
  final insuranceNumberController = TextEditingController();

  DateTime? rcExpiryDate;
  DateTime? insuranceExpiryDate;

  File? rcFile;
  File? insuranceFile;

  Future<DateTime?> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    return picked;
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> addTanker(BuildContext context) async {
    if (tankerNumberController.text.isEmpty ||
        tankerTypeController.text.isEmpty ||
        maxCapacityController.text.isEmpty ||
        rcNumberController.text.isEmpty ||
        insuranceNumberController.text.isEmpty ||
        rcExpiryDate == null ||
        insuranceExpiryDate == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")),
        );
      }
      return;
    }

    final newTanker = TankerModel(
      supplierId: 'dummy_supplier_id', // TODO: Get actual supplier ID
      tankerType: tankerTypeController.text,
      maxCapacity: double.parse(maxCapacityController.text),
      allowedCapacity: double.parse(maxCapacityController.text), // Assuming allowed is same as max for now
      rcNumber: rcNumberController.text,
      insuranceNumber: insuranceNumberController.text,
      taxExpiry: rcExpiryDate!.toIso8601String(), // Assuming rcExpiryDate is taxExpiry
      pollutionExpiry: insuranceExpiryDate!.toIso8601String(), // Assuming insuranceExpiryDate is pollutionExpiry
      vehicleNumber: tankerNumberController.text,
      // Dummy values for other required fields
      fcNumber: 'dummy_fc_number',
      npNumber: 'dummy_np_number',
      lpNumber: 'dummy_lp_number',
      status: 'Idle',
    );

    final response = await TankerService().createTanker(newTanker);

    if (response.success) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tanker added successfully")),
        );
        Navigator.pushReplacementNamed(context, '/supplier-home');
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error ?? "Failed to add tanker")),
        );
      }
    }
  }

  void dispose() {
    tankerNumberController.dispose();
    tankerTypeController.dispose();
    maxCapacityController.dispose();
    rcNumberController.dispose();
    insuranceNumberController.dispose();
  }
}