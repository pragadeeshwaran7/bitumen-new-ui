import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../utils/api_helper.dart';
import 'api_config.dart';
import 'auth_service.dart';

class PaymentService {
  final AuthService _authService = AuthService();
  final Dio _dio = ApiHelper.createDio();
  
  // Initialize with auth token
  Future<void> initialize() async {
    final token = await _authService.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
  
  /// Create payment order
  Future<ApiResponse<Map<String, dynamic>>> createPayment({
    required String orderId,
    required double amount,
    required String currency,
  }) async {
    try {
      developer.log('💳 CREATING PAYMENT', name: 'PaymentService');
      developer.log('📦 Order ID: $orderId', name: 'PaymentService');
      developer.log('💰 Amount: $amount $currency', name: 'PaymentService');
      
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('❌ No authentication token found', name: 'PaymentService');
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('create-payment');
      final body = jsonEncode({
        'orderId': orderId,
        'amount': amount,
        'currency': currency,
      });
      
      developer.log('🌐 Create Payment URL: $url', name: 'PaymentService');
      developer.log('📤 Request Body: $body', name: 'PaymentService');
      
      ApiConfig.logRequest('POST', url, body);
      
      final dio = ApiHelper.createDio();
      final response = await ApiHelper.retryableRequest(() => dio.post(
            url,
            data: jsonDecode(body),
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('create-payment', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        developer.log('✅ Payment created successfully via API', name: 'PaymentService');
        return ApiResponse.success(data['data']);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to create payment');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in createPayment: $e', name: 'PaymentService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Verify payment
  Future<ApiResponse<Map<String, dynamic>>> verifyPayment({
    required String paymentId,
    required String signature,
    required String orderId,
  }) async {
    try {
      developer.log('🔐 VERIFYING PAYMENT', name: 'PaymentService');
      developer.log('💳 Payment ID: $paymentId', name: 'PaymentService');
      developer.log('✍️ Signature: ${signature.substring(0, 20)}...', name: 'PaymentService');
      developer.log('📦 Order ID: $orderId', name: 'PaymentService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('verify-payment');
      final body = jsonEncode({
        'paymentId': paymentId,
        'signature': signature,
        'orderId': orderId,
      });
      
      developer.log('🌐 Verify Payment URL: $url', name: 'PaymentService');
      developer.log('📤 Request Body: $body', name: 'PaymentService');
      
      ApiConfig.logRequest('POST', url, body);
      
      final dio = ApiHelper.createDio();
      final response = await ApiHelper.retryableRequest(() => dio.post(
            url,
            data: jsonDecode(body),
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('verify-payment', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        developer.log('✅ Payment verified successfully via API', name: 'PaymentService');
        return ApiResponse.success(data['data']);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to verify payment');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in verifyPayment: $e', name: 'PaymentService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get payment history
  Future<ApiResponse<List<Map<String, dynamic>>>> getPayments() async {
    try {
      developer.log('📋 GETTING PAYMENT HISTORY', name: 'PaymentService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('payments');
      developer.log('🌐 Payments URL: $url', name: 'PaymentService');
      
      ApiConfig.logRequest('GET', url, null);
      
      final dio = ApiHelper.createDio();
      final response = await ApiHelper.retryableRequest(() => dio.get(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('payments', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final List<dynamic> paymentsJson = data['data'] ?? [];
        final List<Map<String, dynamic>> payments = paymentsJson
            .map((json) => json as Map<String, dynamic>)
            .toList();
          
        developer.log('✅ Payments loaded from API: ${payments.length} payments', name: 'PaymentService');
        return ApiResponse.success(payments);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to get payments');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in getPayments: $e', name: 'PaymentService');
      return ApiResponse.error('Network error: $e');
    }
  }
}

