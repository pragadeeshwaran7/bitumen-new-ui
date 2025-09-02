import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../app/routes/app_routes.dart';
import 'dart:developer' as developer;

class CommonLoginForm extends StatefulWidget {
  final String role;
  
  const CommonLoginForm({super.key, required this.role});

  @override
  State<CommonLoginForm> createState() => _CommonLoginFormState();
}

class _CommonLoginFormState extends State<CommonLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  
  final AuthService _authService = AuthService();
  
  bool _isOtpSent = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }
  
  Future<void> _sendOtp() async {
    // validate phone locally so users can still enter OTP manually if needed
    final phone = _phoneController.text.trim();
  if (phone.isEmpty || !RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit phone number';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid 10-digit phone number'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    developer.log('🚀 Sending OTP to: $phone', name: 'LoginForm');

    final response = await _authService.sendOtp(
      phoneNumber: phone,
    );

    setState(() {
      _isLoading = false;
    });

    if (response.success) {
      setState(() {
        _isOtpSent = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data ?? 'OTP sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      setState(() {
        _errorMessage = response.error;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'Failed to send OTP'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _verifyOtp() async {
    final phone = _phoneController.text.trim();
    final otp = _otpController.text.trim();

    if (phone.isEmpty || !RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit phone number';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid 10-digit phone number'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'OTP must be 6 digits';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP must be 6 digits'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    developer.log('🔐 Verifying OTP for: $phone', name: 'LoginForm');

    try {
      final response = await _authService.loginWithOtp(
        phoneNumber: phone,
        emailAddress: _emailController.text.trim(),
        otp: otp,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.success) {
        final user = response.data!;
        developer.log('✅ Login successful: ${user.toString()}', name: 'LoginForm');

        if (mounted) {
          // Navigate based on user role
          String homeRoute = _getHomeRoute(user.role);
          Navigator.pushReplacementNamed(context, homeRoute);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome, ${user.role}!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = response.error;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      developer.log('❌ OTP verification error: $e', name: 'LoginForm');
      
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected network error occurred. Please try again.';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected network error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  String _getHomeRoute(String role) {
    switch (role.toLowerCase()) {
      case 'customer':
        return AppRoutes.customerHome;
      case 'driver':
        return AppRoutes.driverHome;
      case 'supplier':
        return AppRoutes.supplierHome;
      default:
        return AppRoutes.customerHome;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter your details to continue',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Phone Number Field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            enabled: !_isOtpSent && !_isLoading,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter 10-digit phone number',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter valid 10-digit phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isOtpSent && !_isLoading,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email address';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // OTP Field (shown only after OTP is sent)
          if (_isOtpSent) ...[
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'OTP',
                hintText: 'Enter 6-digit OTP',
                prefixIcon: Icon(Icons.security),
                border: OutlineInputBorder(),
              ),
              maxLength: 6,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the OTP';
                }
                if (value.length != 6) {
                  return 'OTP must be 6 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          
          // Error Message
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Action Button
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : (_isOtpSent ? _verifyOtp : _sendOtp),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(_isOtpSent ? 'Verify & Login' : 'Send OTP'),
          ),
          
          // Help Text
          const SizedBox(height: 16),
          if (!_isOtpSent)
            Text(
              'Tap "Send OTP" to receive a verification code on your phone.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.greyText,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}