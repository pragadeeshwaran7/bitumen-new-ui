import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/utils/validators.dart'; // <-- Import Validators

class SupplierRegistrationForm extends StatefulWidget {
  final VoidCallback onRegistered;
  const SupplierRegistrationForm({super.key, required this.onRegistered});

  @override
  State<SupplierRegistrationForm> createState() => _SupplierRegistrationFormState();
}

class _SupplierRegistrationFormState extends State<SupplierRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final nameController     = TextEditingController();
  final companyController  = TextEditingController();
  final phoneController    = TextEditingController();
  final emailController    = TextEditingController();

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> registerSupplier() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authService.registerSupplier({
      'name':     nameController.text.trim(),
      'company':  companyController.text.trim(),
      'phone':    phoneController.text.trim(),
      'email':    emailController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? 'Registered successfully' : 'Registration failed'),
    ));

    if (success) widget.onRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Register New Supplier',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Name is required' : null,
          ),

          TextFormField(
            controller: companyController,
            decoration: const InputDecoration(labelText: 'Company'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Company name is required' : null,
          ),

          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Phone is required';
              if (!Validators.isPhone(v.trim())) return 'Enter 10-digit phone';
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

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: registerSupplier,
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
