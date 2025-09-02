import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../core/services/tanker_service.dart';
import '../shared/models/tanker_model.dart'; // Import TankerModel

class AddTankerPage extends StatefulWidget {
  const AddTankerPage({super.key});

  @override
  State<AddTankerPage> createState() => _AddTankerPageState();
}

class _AddTankerPageState extends State<AddTankerPage> {
  final TextEditingController tankerNumberController = TextEditingController();
  final TextEditingController tankerTypeController = TextEditingController();
  final TextEditingController maxCapacityController = TextEditingController();
  final TextEditingController rcNumberController = TextEditingController();
  final TextEditingController insuranceNumberController =
      TextEditingController();

  DateTime? rcExpiryDate;
  DateTime? insuranceExpiryDate;

  File? rcFile;
  File? insuranceFile;

  @override
  void dispose() {
    tankerNumberController.dispose();
    tankerTypeController.dispose();
    maxCapacityController.dispose();
    rcNumberController.dispose();
    insuranceNumberController.dispose();
    super.dispose();
  }

  Future<void> pickRCFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        rcFile = File(picked.path);
      });
    }
  }

  Future<void> pickInsuranceFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        insuranceFile = File(picked.path);
      });
    }
  }

  Future<void> pickDate(BuildContext context, bool isRCDate) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        if (isRCDate) {
          rcExpiryDate = picked;
        } else {
          insuranceExpiryDate = picked;
        }
      });
    }
  }

  Future<void> addTanker() async {
    final tankerService = TankerService();
    final tanker = TankerModel(
      supplierId: 'dummy_supplier_id', // TODO: Get actual supplier ID
      tankerType: tankerTypeController.text.trim(),
      maxCapacity: double.tryParse(maxCapacityController.text.trim()) ?? 0.0,
      allowedCapacity: double.tryParse(maxCapacityController.text.trim()) ?? 0.0, // Assuming allowed is same as max for now
      rcNumber: rcNumberController.text.trim(),
      insuranceNumber: insuranceNumberController.text.trim(),
      taxExpiry: rcExpiryDate?.toIso8601String(), // Optional
      pollutionExpiry: insuranceExpiryDate?.toIso8601String(), // Optional
      vehicleNumber: tankerNumberController.text.trim(),
      // Dummy values for other required fields
      fcNumber: 'dummy_fc_number',
      npNumber: 'dummy_np_number',
      lpNumber: 'dummy_lp_number',
      status: 'Idle',
    );

    final result = await tankerService.createTanker(tanker);
    if (!mounted) return;
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tanker added successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add tanker: ${result.error}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Tanker"), leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Tanker",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            buildInput("Tanker Number", tankerNumberController),
            buildInput("Tanker Type", tankerTypeController),
            buildInput("Maximum Capacity", maxCapacityController),
            buildInput("RC Number", rcNumberController),

            buildDateSelector(
              "RC Expiry Date",
              rcExpiryDate,
              () => pickDate(context, true),
            ),
            buildFileUpload("Upload RC Document", rcFile, pickRCFile),

            buildInput("Insurance Number", insuranceNumberController),
            buildDateSelector(
              "Insurance Expiry Date",
              insuranceExpiryDate,
              () => pickDate(context, false),
            ),
            buildFileUpload(
              "Upload Insurance Document",
              insuranceFile,
              pickInsuranceFile,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTanker,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Add Tanker"),
            ),

            const SizedBox(height: 30),
            const Text(
              'By continuing, you agree to our Terms & Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            date != null ? DateFormat.yMMMd().format(date) : 'Select Date',
          ),
        ),
      ),
    );
  }

  Widget buildFileUpload(String label, File? file, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.upload_file),
            label: Text(label),
          ),
          const SizedBox(width: 10),
          Text(
            file != null ? 'File Selected' : 'No File',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}