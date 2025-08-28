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
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gstController.dispose();
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

  Future<void> _registerCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    developer.log('🚀 Registering customer: ${_nameController.text}', name: 'CustomerRegistration');

    try {
      final success = await _authService.registerCustomer(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        gstNumber: _gstController.text.trim(),
  gstFile: _selectedGstFile,
  otp: _otpController.text.trim().isEmpty ? null : _otpController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        developer.log('✅ Customer registration successful', name: 'CustomerRegistration');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Call the callback to switch to login mode
          widget.onRegistered();
        }
      } else {
        setState(() {
          _errorMessage = 'Registration failed. Please try again.';
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
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
            enabled: !_isLoading,
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
            enabled: !_isLoading,
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
            enabled: !_isLoading,
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

          // OTP Field (if user has it)
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              labelText: 'OTP (if received)',
              hintText: 'Enter 6-digit OTP',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            maxLength: 6,
          ),

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

          // Register Button
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
