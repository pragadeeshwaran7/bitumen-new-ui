import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_response.dart';
import '../models/user.dart';
import 'api_config.dart';
import '../utils/api_helper.dart';

class AuthService {
  final Dio _dio = ApiHelper.createDio();
  
  // Store user data
  User? _currentUser;
  
  // Get current user
  User? get currentUser => _currentUser;
  
  // Set current user
  set currentUser(User? user) {
    _currentUser = user;
    _saveUserToPrefs(user);
  }

  // Get token from shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Save token to shared preferences
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    
    // Add token to dio headers for subsequent requests
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  // Save user to shared preferences
  Future<void> _saveUserToPrefs(User? user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString('user', jsonEncode(user.toJson()));
    } else {
      await prefs.remove('user');
    }
  }
  
  // Load user from shared preferences
  Future<User?> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        _currentUser = User.fromJson(userData);
        return _currentUser;
      } catch (e) {
        developer.log('Error loading user from prefs: $e', name: 'AuthService');
      }
    }
    return null;
  }
  
  // Initialize auth state
  Future<bool> initAuth() async {
    final token = await getToken();
    final user = await loadUserFromPrefs();
    
    if (token != null && token.isNotEmpty && user != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      return true;
    }
    return false;
  }

  // Send OTP to phone number
  Future<ServiceResponse<String>> sendOtp({
    required String phoneNumber,
  }) async {
    final String url = ApiConfig.getEndpoint('send-otp');
    try {
      final response = await ApiHelper.retryableRequest(() => _dio.post(
        url,
        data: {'phoneNumber': phoneNumber},
      ));

      final norm = ApiHelper.normalizeResponse(response);

      if ((norm['statusCode'] ?? -1) >= 200 && (norm['statusCode'] ?? -1) < 300) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ServiceResponse(
          success: true,
          data: data['message'] ?? 'OTP sent successfully',
        );
      } else {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ServiceResponse(
          success: false,
          error: data['message'] ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      developer.log('Error sending OTP: $e', name: 'AuthService');
      return ServiceResponse(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Login with OTP
  Future<ServiceResponse<User>> loginWithOtp({
    required String phoneNumber,
    required String otp,
    String? emailAddress,
  }) async {
    final String url = ApiConfig.getEndpoint('login-otp');
    try {
      final Map<String, dynamic> data = {
        'phoneNumber': phoneNumber,
        'otp': otp,
      };
      
      if (emailAddress != null && emailAddress.isNotEmpty) {
        data['emailAddress'] = emailAddress;
      }
      
      final response = await ApiHelper.retryableRequest(() => _dio.post(
        url,
        data: data,
      ));

      final norm = ApiHelper.normalizeResponse(response);

      if ((norm['statusCode'] ?? -1) >= 200 && (norm['statusCode'] ?? -1) < 300) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final user = User.fromJson(data['data']['user']);
        final token = data['data']['token'];
        if (token != null) {
          await setToken(token);
        }
        
        // Save current user
        currentUser = user;
        
        return ServiceResponse(success: true, data: user);
      } else {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ServiceResponse(
          success: false,
          error: data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      developer.log('Error logging in with OTP: $e', name: 'AuthService');
      return ServiceResponse(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<ServiceResponse<User>> registerWithOtp({
    required String phoneNumber,
    required String emailAddress,
    required String role,
    required String otp,
  }) async {
    final String url = ApiConfig.getEndpoint('register-otp');
    try {
      final response = await ApiHelper.retryableRequest(() => _dio.post(
        url,
        data: {
          'phoneNumber': phoneNumber,
          'emailAddress': emailAddress,
          'role': role,
          'otp': otp, // Added missing comma
        },
      ));

      final norm = ApiHelper.normalizeResponse(response);

      if ((norm['statusCode'] ?? -1) >= 200 && (norm['statusCode'] ?? -1) < 300) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final user = User.fromJson(data['data']['user']);
        final token = data['data']['token'];
        if (token != null) {
          await setToken(token);
        }
        
        // Save current user to ensure profile data is available
        currentUser = user;
        
        return ServiceResponse(success: true, data: user);
      } else {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        String errorMessage = data['message'] ?? 'Registration failed';
        if ((norm['statusCode'] ?? -1) == 409) {
          errorMessage = 'User already exists. Please try logging in.';
        }
        return ServiceResponse(
          success: false,
          error: errorMessage,
        );
      }
    } catch (e) {
      developer.log('Error registering with OTP: $e', name: 'AuthService');
      return ServiceResponse(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }
}
