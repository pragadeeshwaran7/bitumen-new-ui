import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/models/driver_model.dart';
import '../../../../core/services/driver_service.dart';
import '../widgets/add_driver/file_upload_widget.dart';
import '../widgets/add_driver/text_input_widget.dart';

class AddDriverPage extends StatefulWidget {
  const AddDriverPage({super.key});

  @override
  State<AddDriverPage> createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();

  File? licenseFile;
  File? aadharFile;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    licenseController.dispose();
    aadharController.dispose();
    super.dispose();
  }

  Future<void> pickLicenseFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => licenseFile = File(picked.path));
    }
  }

  Future<void> pickAadharFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => aadharFile = File(picked.path));
    }
  }

  Future<void> addDriver() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        licenseController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all required fields")));
      }
      return;
    }

    final driver = DriverModel(
      fullName: nameController.text,
      businessAddress: 'N/A', // Dummy value
      licenseNumber: licenseController.text,
      licenseExpiry: '2025-12-31', // Dummy value
      vehicleType: 'truck', // Dummy value
      experience: 0.0, // Dummy value
      documents: {
        'aadharCard': aadharController.text,
        'drivingLicense': licenseController.text, // Using license number as driving license document for now
      },
      bankDetails: {}, // Dummy empty map
      phoneNumber: phoneController.text, // Added phoneNumber
    );

    final response = await DriverService().createDriver(driver);

    if (response.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Driver added successfully")));
        Navigator.pushReplacementNamed(context, '/supplier-home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.error ?? "Failed to add driver")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Driver"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/supplier-home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add New Driver",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CustomTextInput(label: "Full Name", controller: nameController),
            CustomTextInput(
                label: "Phone Number", controller: phoneController),
            CustomTextInput(label: "Email", controller: emailController),
            CustomTextInput(
                label: "License Number", controller: licenseController),
            FileUploadWidget(
                label: "Upload License Document",
                file: licenseFile,
                onPressed: pickLicenseFile),
            CustomTextInput(
                label: "Aadhar Number", controller: aadharController),
            FileUploadWidget(
                label: "Upload Aadhar Document",
                file: aadharFile,
                onPressed: pickAadharFile),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addDriver,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Add Driver"),
            ),
            const SizedBox(height: 30),
            const Text(
              'By continuing, you agree to our Terms & Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.greyText),
            ),
          ],
        ),
      ),
    );
  }
}
