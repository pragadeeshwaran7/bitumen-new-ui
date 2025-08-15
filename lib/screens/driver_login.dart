import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DriverLogin extends StatefulWidget {
  const DriverLogin({super.key});

  @override
  State<DriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  String loginMethod = 'phone';
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> sendLoginOtp() async {
    final uri = Uri.parse('http://10.0.2.2:5000/api/driver/send-otp');
    final body = loginMethod == 'phone'
        ? {'phone': phoneController.text}
        : {'email': emailController.text};

    final response = await http.post(uri, body: body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.statusCode == 200
            ? 'OTP sent successfully'
            : 'Failed to send OTP'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Login via'),
            Row(
              children: [
                Radio(
                  value: 'phone',
                  groupValue: loginMethod,
                  onChanged: (value) => setState(() => loginMethod = value!),
                ),
                const Text('Phone'),
                Radio(
                  value: 'email',
                  groupValue: loginMethod,
                  onChanged: (value) => setState(() => loginMethod = value!),
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
