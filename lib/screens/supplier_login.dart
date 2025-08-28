//import 'dart:io';
import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
// import 'package:http/http.dart' as http;

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({super.key});

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  bool isRegister = false;
  String loginMethod = 'phone'; // 'phone' or 'email'

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> sendLoginOtp() async {
    final auth = AuthService();
    final phone = phoneController.text.trim();
    final result = await auth.sendOtp(phoneNumber: phone);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.success ? 'OTP sent successfully' : 'Failed to send OTP: ${result.error}')),
    );
  }

  Future<void> registerSupplier() async {
    final auth = AuthService();
    final ok = await auth.registerSupplier({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
    });
    if (ok) {
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
      appBar: AppBar(title: const Text('Supplier Login/Registration')),
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
              const Text('Register New Supplier',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerSupplier,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Register'),
              ),
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
