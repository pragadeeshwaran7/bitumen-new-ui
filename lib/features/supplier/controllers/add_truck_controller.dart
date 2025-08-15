import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../data/models/tanker_model.dart';
import '../data/services/tanker_api_service.dart';

class AddTruckController {
  final tankerNumberController = TextEditingController();
  final tankerTypeController = TextEditingController();
  final maxCapacityController = TextEditingController();
  final permissibleLimitController = TextEditingController();
  final rcNumberController = TextEditingController();
  final insuranceNumberController = TextEditingController();
  final fcNumberController = TextEditingController();
  final npNumberController = TextEditingController();

  DateTime? rcExpiryDate;
  DateTime? insuranceExpiryDate;
  DateTime? fcExpiryDate;
  DateTime? npExpiryDate;

  File? rcFile;
  File? insuranceFile;
  File? fcFile;
  File? npFile;

  Future<DateTime> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    return picked ?? now;
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> addTanker(BuildContext context) async {
    if (tankerNumberController.text.isEmpty || rcExpiryDate == null || insuranceExpiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final newTanker = Tanker(
      tankerNo: tankerNumberController.text,
      type: tankerTypeController.text,
      maxQty: maxCapacityController.text,
      allowedQty: permissibleLimitController.text,
      rcNo: rcNumberController.text,
      rcExpiry: rcExpiryDate.toString().split(' ')[0],
      insuranceNo: insuranceNumberController.text,
      insuranceExpiry: insuranceExpiryDate.toString().split(' ')[0],
      status: 'Available',
      driverAssigned: false,
      driverName: null,
      driverPhone: null,
    );

    await TankerApiService().addTanker(newTanker);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tanker added successfully")),
    );

    Navigator.pushReplacementNamed(context, '/supplier-home');
  }
}
