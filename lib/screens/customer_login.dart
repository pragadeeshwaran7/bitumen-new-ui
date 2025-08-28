import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/auth_service.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({super.key});

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  bool isRegister = false;
  String loginMethod = 'phone'; // 'phone' or 'email'

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  File? gstFile;

  Future<void> pickGstFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        gstFile = File(picked.path);
      });
    }
  }
  Future<void> sendLoginOtp() async {
    final auth = AuthService();
  final phone = phoneController.text;

    final resp = await auth.sendOtp(phoneNumber: phone);
    if (resp.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp.data ?? 'OTP sent')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp.error ?? 'Failed to send OTP')),
      );
    }
  }

  Future<void> registerCustomer() async {
    final auth = AuthService();

    final success = await auth.registerCustomer(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      gstNumber: gstController.text,
  gstFile: gstFile,
  otp: otpController.text.trim().isEmpty ? null : otpController.text.trim(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered successfully')),
      );
      setState(() {
        isRegister = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Colors.red;
    final Color unselectedColor = Colors.grey.shade300;

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Login/Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isRegister = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRegister ? unselectedColor : selectedColor,
                      foregroundColor: isRegister ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isRegister = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRegister ? selectedColor : unselectedColor,
                      foregroundColor: isRegister ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (!isRegister) ...[
              const Text('Login via'),
              Row(
                children: [
                  Radio(
                    value: 'phone',
                    groupValue: loginMethod,
                    onChanged: (value) => setState(() {
                      loginMethod = value!;
                    }),
                  ),
                  const Text('Phone'),
                  Radio(
                    value: 'email',
                    groupValue: loginMethod,
                    onChanged: (value) => setState(() {
                      loginMethod = value!;
                    }),
                  ),
                  const Text('Email'),
                ],
              ),
              if (loginMethod == 'phone')
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
              if (loginMethod == 'email')
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendLoginOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Send OTP'),
              ),
            ],

            if (isRegister) ...[
              const Text('Register New Customer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'OTP (if received)'),
              ),
              TextField(
                controller: gstController,
                decoration: const InputDecoration(labelText: 'GST Number'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickGstFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload GST Certificate"),
                  ),
                  const SizedBox(width: 10),
                  Text(gstFile != null ? 'File Selected' : 'No File')
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerCustomer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Register'),
              )
            ],

            const SizedBox(height: 30),
            const Text(
              'By continuing, you agree to our Terms & Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
