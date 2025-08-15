import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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

  Future<void> pickLicenseFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        licenseFile = File(picked.path);
      });
    }
  }

  Future<void> pickAadharFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        aadharFile = File(picked.path);
      });
    }
  }

  Future<void> addDriver() async {
    final uri = Uri.parse('http://10.0.2.2:5000/api/drivers'); // update API endpoint later
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = nameController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['email'] = emailController.text;
    request.fields['license_number'] = licenseController.text;
    request.fields['aadhar_number'] = aadharController.text;

    if (licenseFile != null) {
      final mimeType = lookupMimeType(licenseFile!.path)!.split('/');
      request.files.add(await http.MultipartFile.fromPath(
        'license_document',
        licenseFile!.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ));
    }

    if (aadharFile != null) {
      final mimeType = lookupMimeType(aadharFile!.path)!.split('/');
      request.files.add(await http.MultipartFile.fromPath(
        'aadhar_document',
        aadharFile!.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ));
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Driver added successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add driver")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Driver"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Add New Driver", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          buildInput("Full Name", nameController),
          buildInput("Phone Number", phoneController),
          buildInput("Email", emailController),
          buildInput("License Number", licenseController),
          buildFileUpload("Upload License Document", licenseFile, pickLicenseFile),
          buildInput("Aadhar Number", aadharController),
          buildFileUpload("Upload Aadhar Document", aadharFile, pickAadharFile),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: addDriver,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Add Driver"),
          ),

          const SizedBox(height: 30),
          const Text(
            'By continuing, you agree to our Terms & Conditions and Privacy Policy',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ]),
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

  Widget buildFileUpload(String label, File? file, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.upload_file),
          label: Text(label),
        ),
        const SizedBox(width: 10),
        Text(file != null ? 'File Selected' : 'No File', style: const TextStyle(color: Colors.grey)),
      ]),
    );
  }
}
