import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/services/auth_service.dart';
import 'dart:developer' as developer;

class SupplierRegistrationForm extends StatefulWidget {
  final VoidCallback onRegistered;

  const SupplierRegistrationForm({
    super.key,
    required this.onRegistered,
  });

  @override
  State<SupplierRegistrationForm> createState() => _SupplierRegistrationFormState();
}

class _SupplierRegistrationFormState extends State<SupplierRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactPersonController = TextEditingController();
  File? _selectedGstFile;
  
  Future<void> _pickGstFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedGstFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      developer.log('❌ Error picking GST file: $e', name: 'SupplierRegistration');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
  
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _companyNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _addressController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  Future<void> _registerSupplier() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    developer.log('🚀 Registering supplier: ${_companyNameController.text}', name: 'SupplierRegistration');

    try {
      final supplierData = {
        'companyName': _companyNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'emailAddress': _emailController.text.trim(),
        'gstNumber': _gstController.text.trim(),
        'address': _addressController.text.trim(),
        'contactPerson': _contactPersonController.text.trim(),
        'role': 'supplier',
      };

      final success = await _authService.registerSupplier(supplierData, gstFile: _selectedGstFile);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        developer.log('✅ Supplier registration successful', name: 'SupplierRegistration');
        
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
      developer.log('❌ Registration error: $e', name: 'SupplierRegistration');
      
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
            'Create Supplier Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Company Name Field
          TextFormField(
            controller: _companyNameController,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              labelText: 'Company Name',
              hintText: 'Enter company name',
              prefixIcon: Icon(Icons.business),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter company name';
              }
              if (value.length < 2) {
                return 'Company name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Contact Person Field
          TextFormField(
            controller: _contactPersonController,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              labelText: 'Contact Person',
              hintText: 'Enter contact person name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter contact person name';
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
              hintText: 'Enter company email',
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
              hintText: 'Enter GST number',
              prefixIcon: Icon(Icons.receipt),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter GST number';
              }
              if (value.length != 15) {
                return 'GST number should be 15 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // GST File Upload (optional)
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
              trailing: _isLoading ? null : const Icon(Icons.upload),
              onTap: _isLoading ? null : _pickGstFile,
            ),
          ),
          const SizedBox(height: 16),

          // Address Field
          TextFormField(
            controller: _addressController,
            maxLines: 3,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              labelText: 'Business Address',
              hintText: 'Enter complete business address',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter business address';
              }
              return null;
            },
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
            onPressed: _isLoading ? null : _registerSupplier,
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
