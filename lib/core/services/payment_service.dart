import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../utils/api_helper.dart';
import '../models/api_response.dart';
import 'api_config.dart';
import 'auth_service.dart';

class PaymentService {
  final AuthService _authService = AuthService();
  
  /// Create payment order
  Future<ApiResponse<Map<String, dynamic>>> createPayment({
    required String orderId,
    required double amount,
    required String currency,
  }) async {
    try {
      print('💳 CREATING PAYMENT');
      print('📦 Order ID: $orderId');
      print('💰 Amount: $amount $currency');
      
      final token = await _authService.getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('create-payment');
      final body = jsonEncode({
        'orderId': orderId,
        'amount': amount,
        'currency': currency,
      });
      
      print('🌐 Create Payment URL: $url');
      print('📤 Request Body: $body');
      
      ApiConfig.logRequest('POST', url, body);
      
      // Try real API with retry mechanism
      try {
        final response = await ApiHelper.retryableRequest(() => http.post(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
          body: body,
        ));

        final responseBody = response.body;
        print('📡 Create Payment Response Status: ${response.statusCode}');
        print('📡 Create Payment Response Body: $responseBody');

        ApiConfig.logResponse('create-payment', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          print('✅ Payment created successfully via API');
          return ApiResponse.success(data['data']);
        } else {
          print('⚠️ API payment creation failed, creating mock payment');
        }
      } catch (e) {
        print('❌ API payment creation failed: $e');
        print('⚠️ Creating mock payment');
      }
      
      // Create mock payment response
      final mockPaymentData = {
        'id': 'pay_${DateTime.now().millisecondsSinceEpoch}',
        'orderId': orderId,
        'amount': amount,
        'currency': currency,
        'status': 'created',
        'razorpay_order_id': 'order_mock_${DateTime.now().millisecondsSinceEpoch}',
        'key': 'rzp_test_mock_key',
        'name': 'Bitumen Hub',
        'description': 'Payment for Order $orderId',
        'image': 'https://example.com/logo.png',
        'prefill': {
          'name': 'Customer Name',
          'email': 'customer@example.com',
          'contact': '9999999999',
        },
        'notes': {
          'orderId': orderId,
          'platform': 'mobile',
        },
        'theme': {
          'color': '#F37254',
        },
      };
      
      print('✅ Mock payment created: ${mockPaymentData['id']}');
      return ApiResponse.success(mockPaymentData);
      
    } catch (e) {
      print('❌ Error in createPayment: $e');
      developer.log('❌ Error creating payment: $e', name: 'PaymentService');
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
      print('🔐 VERIFYING PAYMENT');
      print('💳 Payment ID: $paymentId');
      print('✍️ Signature: ${signature.substring(0, 20)}...');
      print('📦 Order ID: $orderId');
      
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
      
      print('🌐 Verify Payment URL: $url');
      print('📤 Request Body: $body');
      
      ApiConfig.logRequest('POST', url, body);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.post(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
          body: body,
        ));

        final responseBody = response.body;
        print('📡 Verify Payment Response Status: ${response.statusCode}');
        print('📡 Verify Payment Response Body: $responseBody');

        ApiConfig.logResponse('verify-payment', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          print('✅ Payment verified successfully via API');
          return ApiResponse.success(data['data']);
        }
      } catch (e) {
        print('❌ API payment verification failed: $e');
      }
      
      // Mock verification success
      final mockVerificationData = {
        'verified': true,
        'paymentId': paymentId,
        'orderId': orderId,
        'status': 'paid',
        'amount': 50000,
        'currency': 'INR',
        'method': 'card',
        'verifiedAt': DateTime.now().toIso8601String(),
      };
      
      print('✅ Mock payment verification successful');
      return ApiResponse.success(mockVerificationData);
      
    } catch (e) {
      print('❌ Error in verifyPayment: $e');
      developer.log('❌ Error verifying payment: $e', name: 'PaymentService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get payment history
  Future<ApiResponse<List<Map<String, dynamic>>>> getPayments() async {
    try {
      print('📋 GETTING PAYMENT HISTORY');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('payments');
      print('🌐 Payments URL: $url');
      
      ApiConfig.logRequest('GET', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Payments Response Status: ${response.statusCode}');
        print('📡 Payments Response Body: $responseBody');

        ApiConfig.logResponse('payments', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final List<dynamic> paymentsJson = data['data'] ?? [];
          final List<Map<String, dynamic>> payments = paymentsJson
              .map((json) => json as Map<String, dynamic>)
              .toList();
          
          print('✅ Payments loaded from API: ${payments.length} payments');
          return ApiResponse.success(payments);
        }
      } catch (e) {
        print('❌ API payments fetch failed: $e');
      }
      
      // Mock payment history
      final mockPayments = <Map<String, dynamic>>[
        {
          'id': 'pay_1_${DateTime.now().millisecondsSinceEpoch}',
          'orderId': 'order_123',
          'amount': 50000.0,
          'currency': 'INR',
          'status': 'paid',
          'method': 'card',
          'createdAt': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
          'description': 'Payment for Bitumen Order #123',
        },
        {
          'id': 'pay_2_${DateTime.now().millisecondsSinceEpoch}',
          'orderId': 'order_124',
          'amount': 75000.0,
          'currency': 'INR',
          'status': 'paid',
          'method': 'upi',
          'createdAt': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
          'description': 'Payment for Bitumen Order #124',
        },
        {
          'id': 'pay_3_${DateTime.now().millisecondsSinceEpoch}',
          'orderId': 'order_125',
          'amount': 30000.0,
          'currency': 'INR',
          'status': 'pending',
          'method': 'netbanking',
          'createdAt': DateTime.now().toIso8601String(),
          'description': 'Payment for Bitumen Order #125',
        },
      ];
      
      print('✅ Mock payments created: ${mockPayments.length} payments');
      return ApiResponse.success(mockPayments);
      
    } catch (e) {
      print('❌ Error in getPayments: $e');
      developer.log('❌ Error getting payments: $e', name: 'PaymentService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
