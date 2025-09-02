import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../../core/services/api_config.dart';
import '../../../../core/utils/api_helper.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/models/order_model.dart'; // Updated import

class CustomerPaymentApiService {
  static final CustomerPaymentApiService _instance = CustomerPaymentApiService._internal();
  factory CustomerPaymentApiService() => _instance;
  CustomerPaymentApiService._internal();

  final AuthService _authService = AuthService();
  final Dio _dio = ApiHelper.createDio(); // Added Dio instance

  Future<List<OrderModel>> fetchPayments({String filter = 'All'}) async { // Changed return type
    try {
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('No authentication token found', name: 'CustomerPaymentService');
        return [];
      }

      final url = ApiConfig.getEndpoint('payments');
      ApiConfig.logRequest('GET', url, null);
      
      final response = await ApiHelper.retryableRequest(() => _dio.get(
        url,
        options: Options(headers: ApiConfig.getHeaders(token: token)),
      ));

      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('payments', norm['statusCode'] ?? -1, norm['text']);

      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        if (data != null && data['data'] is List) {
          final payments = (data['data'] as List)
              .map((paymentJson) => OrderModel.fromJson(paymentJson)) // Changed to OrderModel
              .toList();

          // Apply filter if specified
          if (filter != 'All') {
            return payments.where((payment) => payment.status?.toLowerCase() == filter.toLowerCase()).toList();
          }
          return payments;
        }
      }

      developer.log('Failed to fetch payments: ${norm['text']}', name: 'CustomerPaymentService');
      return [];
    } catch (e) {
      developer.log('Error fetching payments: $e', name: 'CustomerPaymentService');
      return [];
    }
  }

  Future<bool> createPayment({required double amount, required String receipt, String currency = 'INR'}) async { // Changed parameters
    try {
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('No authentication token found', name: 'CustomerPaymentService');
        return false;
      }

      final url = ApiConfig.getEndpoint('create-payment');
      final body = {
        'amount': amount,
        'receipt': receipt,
        'currency': currency,
      };
      ApiConfig.logRequest('POST', url, jsonEncode(body));
      
      final response = await ApiHelper.retryableRequest(() => _dio.post(
        url,
        data: body,
        options: Options(headers: ApiConfig.getHeaders(token: token)),
      ));

      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('create-payment', norm['statusCode'] ?? -1, norm['text']);

      return (norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201;
    } catch (e) {
      developer.log('Error creating payment: $e', name: 'CustomerPaymentService');
      return false;
    }
  }

  Future<bool> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required String orderId,
  }) async { // Changed parameters
    try {
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('No authentication token found', name: 'CustomerPaymentService');
        return false;
      }

      final url = ApiConfig.getEndpoint('verify-payment');
      final payload = {
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
        'orderId': orderId,
      };
      ApiConfig.logRequest('POST', url, jsonEncode(payload));
      
      final response = await ApiHelper.retryableRequest(() => _dio.post(
        url,
        data: payload,
        options: Options(headers: ApiConfig.getHeaders(token: token)),
      ));

      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('verify-payment', norm['statusCode'] ?? -1, norm['text']);

      return (norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201;
    } catch (e) {
      developer.log('Error verifying payment: $e', name: 'CustomerPaymentService');
      return false;
    }
  }
}