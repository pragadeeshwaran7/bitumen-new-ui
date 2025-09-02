import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/auth_service.dart';
import 'dart:developer' as developer;

class CustomerRegistrationForm extends StatefulWidget {
  final VoidCallback onRegistered;

  const CustomerRegistrationForm({
    super.key,
    required this.onRegistered,
  });

  @override
  State<CustomerRegistrationForm> createState() => _CustomerRegistrationFormState();
}

class _CustomerRegistrationFormState extends State<CustomerRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _otpController = TextEditingController();
  
  final AuthService _authService = AuthService();
  
  File? _selectedGstFile;
  bool _isLoading = false;
  bool _isOtpSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _pickGstFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _selectedGstFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      developer.log('❌ Error picking file: $e', name: 'CustomerRegistration');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendOtp() async {
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

    developer.log('🚀 Sending OTP for registration to: $phone', name: 'CustomerRegistration');

    final response = await _authService.sendOtp(phoneNumber: phone);

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

  Future<void> _registerCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isOtpSent) {
      setState(() {
        _errorMessage = 'Please send OTP first';
      });
      return;
    }

    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    developer.log('🚀 Registering customer...', name: 'CustomerRegistration');

    try {
      final response = await _authService.registerWithOtp(
        phoneNumber: _phoneController.text.trim(),
        emailAddress: _emailController.text.trim(),
        role: 'customer',
        otp: otp,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.success) {
        developer.log('✅ Customer registration successful', name: 'CustomerRegistration');
        
        // Save additional customer details to profile
        final user = response.data;
        developer.log('User data: ${user.toString()}', name: 'CustomerRegistration');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Redirecting to home...'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate directly to customer home screen
          Navigator.of(context).pushNamedAndRemoveUntil('/customer/home', (route) => false);
        }
      } else {
        setState(() {
          _errorMessage = response.error ?? 'Registration failed. Please try again.';
        });
        
        if (mounted) {
          if (response.error == 'User already exists. Please try logging in.') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.error!),
                backgroundColor: Colors.orange,
              ),
            );
            // Optionally navigate to login or show a login button
            // Navigator.pushReplacementNamed(context, '/login');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.error ?? 'Registration failed. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      developer.log('❌ Registration error: $e', name: 'CustomerRegistration');
      
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error. Please check your connection.';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
            'Create Customer Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Name Field
          TextFormField(
            controller: _nameController,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            enabled: !_isLoading && !_isOtpSent,
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
            enabled: !_isLoading && !_isOtpSent,
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

          // GST Number Field
          TextFormField(
            controller: _gstController,
            enabled: !_isLoading && !_isOtpSent,
            decoration: const InputDecoration(
              labelText: 'GST Number',
              hintText: 'Enter GST number (optional)',
              prefixIcon: Icon(Icons.business),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              // GST validation is optional for customers
              if (value != null && value.isNotEmpty) {
                if (value.length != 15) {
                  return 'GST number should be 15 characters';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Send OTP Button (shown only before OTP is sent)
          if (!_isOtpSent) ...[
            ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
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
                  : const Text('Send OTP'),
            ),
            const SizedBox(height: 16),
          ],

          // OTP Field (shown only after OTP is sent)
          if (_isOtpSent) ...[
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'OTP',
                hintText: 'Enter 6-digit OTP',
                prefixIcon: Icon(Icons.lock),
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

          // GST File Upload
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.attach_file),
              title: Text(_selectedGstFile == null 
                  ? 'Upload GST Certificate (Optional)' 
                  : 'GST Certificate Selected'),
              subtitle: _selectedGstFile != null 
                  ? Text(_selectedGstFile!.path.split('/').last)
                  : const Text('PDF, JPG, PNG files allowed'),
              trailing: _isLoading 
                  ? null 
                  : const Icon(Icons.upload),
              onTap: _isLoading ? null : _pickGstFile,
            ),
          ),
          const SizedBox(height: 16),

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

          // Register Button (shown only after OTP is sent)
          if (_isOtpSent) ...[
            ElevatedButton(
              onPressed: _isLoading ? null : _registerCustomer,
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
                  : const Text('Create Account'),
            ),
          ],

          const SizedBox(height: 16),
          Text(
            'After registration, you can login with your phone number and email.',
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