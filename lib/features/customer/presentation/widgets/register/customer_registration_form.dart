import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/utils/validators.dart';          // <-- import validators

class CustomerRegistrationForm extends StatefulWidget {
  final VoidCallback onRegistered;
  const CustomerRegistrationForm({super.key, required this.onRegistered});

  @override
  State<CustomerRegistrationForm> createState() => _CustomerRegistrationFormState();
}

class _CustomerRegistrationFormState extends State<CustomerRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final nameController  = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final gstController   = TextEditingController();
  File? gstFile;

  Future<void> pickGstFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => gstFile = File(picked.path));
  }

  Future<void> registerCustomer() async {
    // validate form
    if (!_formKey.currentState!.validate()) return;

    if (gstFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload GST certificate')),
      );
      return;
    }

    final success = await _authService.registerCustomer(
      name:      nameController.text.trim(),
      phone:     phoneController.text.trim(),
      email:     emailController.text.trim(),
      gstNumber: gstController.text.trim(),
      gstFile:   gstFile,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered successfully')),
      );
      widget.onRegistered();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Register New Customer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Name is required' : null,
          ),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Phone is required';
              if (!Validators.isPhone(v.trim())) return 'Enter 10‑digit phone';
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!Validators.isEmail(v.trim())) return 'Enter valid email';
              return null;
            },
          ),
          TextFormField(
            controller: gstController,
            decoration: const InputDecoration(labelText: 'GST Number'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'GST number required' : null,
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: pickGstFile,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload GST Certificate'),
              ),
              const SizedBox(width: 10),
              Text(gstFile != null ? 'File Selected' : 'No File'),
            ],
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: registerCustomer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
