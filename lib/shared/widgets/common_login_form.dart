import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/validators.dart';
import '../../../core/services/auth_service.dart';

class CommonLoginForm extends StatefulWidget {
  final String role;

  const CommonLoginForm({super.key, required this.role});

  @override
  State<CommonLoginForm> createState() => _CommonLoginFormState();
}

class _CommonLoginFormState extends State<CommonLoginForm> {
  final _formKey = GlobalKey<FormState>();
  String loginMethod = 'phone';
  bool otpSent = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final value = loginMethod == 'phone'
        ? phoneController.text.trim()
        : emailController.text.trim();

    final success = await _authService.sendOtp(
      method: loginMethod,
      value: value,
    );

    if (success) {
      setState(() => otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    final value = loginMethod == 'phone'
        ? phoneController.text.trim()
        : emailController.text.trim();
    final otp = otpController.text.trim();

    final verified = await _authService.verifyOtp(
      method: loginMethod,
      value: value,
      otp: otp,
    );

    if (verified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified')),
      );

      switch (widget.role) {
        case 'customer':
          Navigator.pushReplacementNamed(context, '/customer-home');
          break;
        case 'supplier':
          Navigator.pushReplacementNamed(context, '/supplier-home');
          break;
        case 'driver':
          Navigator.pushReplacementNamed(context, '/driver-home');
          break;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
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
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter phone number';
                }
                if (!Validators.isPhone(value.trim())) {
                  return 'Enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
          if (loginMethod == 'email')
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email Address'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email address';
                }
                if (!Validators.isEmail(value.trim())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Send OTP'),
          ),
          if (otpSent) ...[
            const SizedBox(height: 20),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Verify OTP'),
            ),
          ],
        ],
      ),
    );
  }
}
