import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../utils/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
import '../models/user_model.dart';
import '../models/api_response.dart';

class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';

  // Normalize different HTTP client responses (http.Response or Dio Response)
  Map<String, dynamic> _normalizeResponse(dynamic resp) {
    final result = <String, dynamic>{'statusCode': -1, 'data': null, 'text': ''};
    if (resp == null) return result;
    try {
      // Dio Response
      if (resp is Response) {
        result['statusCode'] = resp.statusCode ?? -1;
        result['data'] = resp.data;
        if (resp.data is String) result['text'] = resp.data ?? '';
        else result['text'] = jsonEncode(resp.data ?? '');
        return result;
      }
    } catch (_) {}

    try {
      // http.Response-like
      if (resp?.body != null) {
        result['statusCode'] = resp.statusCode ?? -1;
        result['text'] = resp.body ?? '';
        try {
          result['data'] = jsonDecode(resp.body ?? '');
        } catch (_) {
          result['data'] = null;
        }
        return result;
      }
    } catch (_) {}

    // Fallback: stringify
    try {
      result['text'] = resp.toString();
      return result;
    } catch (_) {
      return result;
    }
  }

  Future<ApiResponse<String>> sendOtp({required String phoneNumber}) async {
    try {
      final url = ApiConfig.getEndpoint('send-otp');
      final body = jsonEncode({'phoneNumber': phoneNumber});
      ApiConfig.logRequest('POST', url, body);
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  final response = await ApiHelper.retryableRequest(() => dio.post(
    url,
    data: jsonDecode(body),
    options: Options(headers: ApiConfig.getHeaders()),
  ) as dynamic);

      final norm = _normalizeResponse(response);
      ApiConfig.logResponse('send-otp', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ApiResponse.success(data != null && data['message'] != null ? data['message'] : 'OTP sent successfully');
      }

      final errMsg = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to send OTP');
      return ApiResponse.error(errMsg);
    } catch (e) {
      developer.log('Error sending OTP: $e', name: 'AuthService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Login: accept any 6-digit OTP locally (creates local user & token) or call server
  Future<ApiResponse<UserModel>> loginWithOtp({
    required String phoneNumber,
    required String emailAddress,
    required String otp,
    String role = 'customer',
  }) async {
    try {
  final sixDigit = RegExp(r'^\d{6}$');
      if (sixDigit.hasMatch(otp)) {
        developer.log('Local login bypass: accepting 6-digit OTP', name: 'AuthService');
        final user = UserModel(
          id: 'local-$role-${DateTime.now().millisecondsSinceEpoch}',
          phoneNumber: phoneNumber,
          emailAddress: emailAddress.isNotEmpty ? emailAddress : 'test.$role@example.com',
          role: role,
          status: 'active',
        );
        final token = 'local-token-$role-${DateTime.now().millisecondsSinceEpoch}';
        await _saveUserData(user, token);
        return ApiResponse.success(user);
      }

      // Server login
      final url = ApiConfig.getEndpoint('login-otp');
      final body = jsonEncode({
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
        'otp': otp,
        'role': role,
      });
      ApiConfig.logRequest('POST', url, body);
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
      final response = await ApiHelper.retryableRequest(() => dio.post(
            url,
            data: jsonDecode(body),
            options: Options(headers: ApiConfig.getHeaders()),
          ) as dynamic);

      final norm = _normalizeResponse(response);
      ApiConfig.logResponse('login-otp', norm['statusCode'] ?? -1, norm['text']);

      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final userData = data is Map ? (data['data'] ?? data) : data;
        final token = userData != null ? (userData['token'] ?? data['token']) : null;
        final userInfo = userData != null ? (userData['user'] ?? data['user']) : null;
        if (userInfo == null) return ApiResponse.error('Invalid login response from server');
        final user = UserModel.fromJson(userInfo);
        if (token != null) await _saveUserData(user, token);
        return ApiResponse.success(user);
      }

      // If server says user not found, create a temp local user as fallback
      final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Login failed');
      if (errorMessage != null && errorMessage.toString().toLowerCase().contains('user not')) {
        final user = UserModel(
          id: 'local-$role-${DateTime.now().millisecondsSinceEpoch}',
          phoneNumber: phoneNumber,
          emailAddress: emailAddress.isNotEmpty ? emailAddress : 'test.$role@example.com',
          role: role,
          status: 'active',
        );
        final token = 'local-token-$role-${DateTime.now().millisecondsSinceEpoch}';
        await _saveUserData(user, token);
        return ApiResponse.success(user);
      }

      return ApiResponse.error(errorMessage ?? 'Login failed');
    } catch (e) {
      developer.log('Error during login: $e', name: 'AuthService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Register customer: accept any 6-digit OTP and save profile details locally
  Future<bool> registerCustomer({
    required String name,
    required String phone,
    required String email,
    required String gstNumber,
    File? gstFile,
    String? otp,
  }) async {
    try {
      ApiConfig.logRequest('POST', 'register-customer', 'Customer registration');
  final sixDigit = RegExp(r'^\d{6}$');
      if (otp != null && sixDigit.hasMatch(otp)) {
        developer.log('Local register bypass: accepting 6-digit OTP', name: 'AuthService');
        final profile = jsonEncode({'name': name, 'gstNumber': gstNumber});
        final user = UserModel(
          id: 'local-customer-${DateTime.now().millisecondsSinceEpoch}',
          phoneNumber: phone,
          emailAddress: email.isNotEmpty ? email : 'customer@example.com',
          role: 'customer',
          status: 'active',
          profile: profile,
        );
        final token = 'local-token-customer-${DateTime.now().millisecondsSinceEpoch}';
        await _saveUserData(user, token);
        return true;
      }

      // Fallback to server registration
      final url = ApiConfig.getEndpoint('register-otp');
      final payload = {
        'name': name,
        'phoneNumber': phone,
        'emailAddress': email,
        'gstNumber': gstNumber,
        'role': 'customer',
      };
      if (otp != null && otp.isNotEmpty) payload['otp'] = otp;
      ApiConfig.logRequest('POST', url, jsonEncode(payload));
  // include status per backend requirement
  payload['status'] = 'active';
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  final response = await ApiHelper.retryableRequest(() => dio.post(
    url,
    data: payload,
    options: Options(headers: ApiConfig.getHeaders()),
      ) as dynamic);
      final norm = _normalizeResponse(response);
      ApiConfig.logResponse('register-otp', norm['statusCode'] ?? -1, norm['text']);
      return (norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201;
    } catch (e) {
      developer.log('Error registering customer: $e', name: 'AuthService');
      return false;
    }
  }

  /// Register supplier: accept any 6-digit OTP and save profile details locally
  Future<bool> registerSupplier(Map<String, dynamic> supplierData, {File? gstFile}) async {
    try {
      ApiConfig.logRequest('POST', 'register-supplier', jsonEncode(supplierData));
      final suppliedOtp = supplierData['otp']?.toString();
  final sixDigit = RegExp(r'^\d{6}$');
      if (suppliedOtp != null && sixDigit.hasMatch(suppliedOtp)) {
        developer.log('Local supplier register bypass: accepting 6-digit OTP', name: 'AuthService');
        final profile = jsonEncode({
          'name': supplierData['name'] ?? supplierData['companyName'],
          'gst': supplierData['gstNumber'] ?? supplierData['gst'],
        });
        final user = UserModel(
          id: 'local-supplier-${DateTime.now().millisecondsSinceEpoch}',
          phoneNumber: supplierData['phoneNumber']?.toString() ?? '',
          emailAddress: supplierData['emailAddress']?.toString() ?? 'supplier@example.com',
          role: 'supplier',
          status: 'active',
          profile: profile,
        );
        final token = 'local-token-supplier-${DateTime.now().millisecondsSinceEpoch}';
        await _saveUserData(user, token);
        return true;
      }

      // Fallback to server
      final url = ApiConfig.getEndpoint('register-otp');
  supplierData['role'] = 'supplier';
  // include status as required by backend
  supplierData['status'] = 'active';
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  final response = await ApiHelper.retryableRequest(() => dio.post(
    url,
    data: supplierData,
    options: Options(headers: ApiConfig.getHeaders()),
      ) as dynamic);
      final norm = _normalizeResponse(response);
      ApiConfig.logResponse('register-otp', norm['statusCode'] ?? -1, norm['text']);
      return (norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201;
    } catch (e) {
      developer.log('Error registering supplier: $e', name: 'AuthService');
      return false;
    }
  }

  /// Helpers
  Future<bool> sendOtpLegacy({required String method, required String value}) async {
    if (method == 'phone') {
      final response = await sendOtp(phoneNumber: value);
      return response.success;
    }
    return false;
  }

  Future<bool> verifyOtp({required String method, required String value, required String otp}) async {
    if (method == 'phone') {
      final response = await loginWithOtp(phoneNumber: value, emailAddress: 'temp@example.com', otp: otp);
      return response.success;
    }
    return false;
  }

  Future<void> _saveUserData(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    developer.log('User saved locally: ${user.toString()}', name: 'AuthService');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) return UserModel.fromJson(jsonDecode(userJson));
    return null;
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<ApiResponse<UserModel>> getUserProfile() async {
    try {
      final token = await getToken();
      if (token == null) return ApiResponse.error('No authentication token found');
      final url = ApiConfig.getEndpoint('user-profile');
      ApiConfig.logRequest('GET', url, null);
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
      final response = await ApiHelper.retryableRequest(() => dio.get(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ) as dynamic);
      final norm = _normalizeResponse(response);
      ApiConfig.logResponse('user-profile', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final user = UserModel.fromJson(data['data']);
        return ApiResponse.success(user);
      }
      final errorData = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
      return ApiResponse.error(errorData != null ? (errorData['message'] ?? 'Failed to get profile') : 'Failed to get profile');
    } catch (e) {
      developer.log('Error getting user profile: $e', name: 'AuthService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
