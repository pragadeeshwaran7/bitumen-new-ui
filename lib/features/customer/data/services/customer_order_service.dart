import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../../core/services/api_config.dart';
import '../../../../core/utils/api_helper.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/models/order_model.dart'; // Updated import

class CustomerApiService {
  static final CustomerApiService _instance = CustomerApiService._internal();
  factory CustomerApiService() => _instance;
  CustomerApiService._internal();

  final AuthService _authService = AuthService();
  final Dio _dio = ApiHelper.createDio(); // Added Dio instance

  Future<List<OrderModel>> fetchOrders({String filter = 'All'}) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('No authentication token found', name: 'CustomerOrderService');
        return [];
      }

      final url = ApiConfig.getEndpoint('orders');
      ApiConfig.logRequest('GET', url, null);
      
      final response = await ApiHelper.retryableRequest(() => _dio.get(
        url,
        options: Options(headers: ApiConfig.getHeaders(token: token)),
      ));

      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('orders', norm['statusCode'] ?? -1, norm['text']);

      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        if (data != null && data['data'] is List) {
          final orders = (data['data'] as List)
              .map((orderJson) => OrderModel.fromJson(orderJson))
              .toList();

          // Apply filter if specified
          if (filter != 'All') {
            return orders.where((order) => order.status?.toLowerCase() == filter.toLowerCase()).toList();
          }
          return orders;
        }
      }

      developer.log('Failed to fetch orders: ${norm['text']}', name: 'CustomerOrderService');
      return [];
    } catch (e) {
      developer.log('Error fetching orders: $e', name: 'CustomerOrderService');
      return [];
    }
  }

  Future<OrderModel?> createOrder(OrderModel order) async { // Changed parameter type
    try {
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('No authentication token found', name: 'CustomerOrderService');
        return null;
      }

      final url = ApiConfig.getEndpoint('create-order');
      final body = order.toJson(); // Use toJson()
      print('Request body: ' + jsonEncode(body));
      print('POSTing to: $url');
      ApiConfig.logRequest('POST', url, jsonEncode(body));
      
      final response = await ApiHelper.retryableRequest(() => _dio.post(
        url,
        data: body, // Pass as map
        options: Options(headers: ApiConfig.getHeaders(token: token)),
      ));
      print('Response: ' + response.toString());

      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('create-order', norm['statusCode'] ?? -1, norm['text']);

      if ((norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        if (data != null && data['data'] != null) {
          return OrderModel.fromJson(data['data']);
        }
      }

      developer.log('Failed to create order: ${norm['text']}', name: 'CustomerOrderService');
      return null;
    } catch (e) {
      print('Dio error: $e');
      developer.log('Error creating order: $e', name: 'CustomerOrderService');
      return null;
    }
  }
}