import 'dart:convert';

import 'package:bitumen_hub/core/models/order_model.dart';
import 'package:bitumen_hub/core/models/service_response.dart';
import 'package:bitumen_hub/core/services/api_config.dart';
import 'package:bitumen_hub/core/utils/api_helper.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class OrderService {
  final Dio _dio = ApiHelper.createDio();

  Future<ServiceResponse<Order>> createOrder({
    required String pickupLocation,
    required String dropoffLocation,
    required double quantity,
    required String product,
  }) async {
    final String url = ApiConfig.getEndpoint('create-order');
    try {
      final response = await ApiHelper.retryableRequest(() => _dio.post(
            url,
            data: {
              'pickupLocation': pickupLocation,
              'dropoffLocation': dropoffLocation,
              'quantity': quantity,
              'product': product,
            },
          ));

      final norm = ApiHelper.normalizeResponse(response);

      if ((norm['statusCode'] ?? -1) >= 200 && (norm['statusCode'] ?? -1) < 300) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final order = Order.fromJson(data['data']);
        return ServiceResponse(success: true, data: order);
      } else {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ServiceResponse(
          success: false,
          error: data['message'] ?? 'Failed to create order',
        );
      }
    } catch (e) {
      developer.log('Error creating order: $e', name: 'OrderService');
      return ServiceResponse(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<ServiceResponse<List<Order>>> getAssignedOrders() async {
    final String url = ApiConfig.getEndpoint('driver-dashboard');
    try {
      final response = await ApiHelper.retryableRequest(() => _dio.get(url));

      final norm = ApiHelper.normalizeResponse(response);

      if ((norm['statusCode'] ?? -1) >= 200 && (norm['statusCode'] ?? -1) < 300) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final orders = (data['data'] as List).map((orderData) => Order.fromJson(orderData)).toList();
        return ServiceResponse(success: true, data: orders);
      } else {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ServiceResponse(
          success: false,
          error: data['message'] ?? 'Failed to fetch assigned orders',
        );
      }
    } catch (e) {
      developer.log('Error fetching assigned orders: $e', name: 'OrderService');
      return ServiceResponse(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<ServiceResponse<List<Order>>> getSupplierOrders() async {
    final String url = ApiConfig.getEndpoint('all-orders');
    try {
      final response = await ApiHelper.retryableRequest(() => _dio.get(url));

      final norm = ApiHelper.normalizeResponse(response);

      if ((norm['statusCode'] ?? -1) >= 200 && (norm['statusCode'] ?? -1) < 300) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final orders = (data['data'] as List).map((orderData) => Order.fromJson(orderData)).toList();
        return ServiceResponse(success: true, data: orders);
      } else {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ServiceResponse(
          success: false,
          error: data['message'] ?? 'Failed to fetch supplier orders',
        );
      }
    } catch (e) {
      developer.log('Error fetching supplier orders: $e', name: 'OrderService');
      return ServiceResponse(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<ServiceResponse<Order>> assignTankerToOrder({
    required String orderId,
    required String tankerId,
  }) async {
    final String url = ApiConfig.getEndpoint('update-order-status', pathParams: {'id': orderId});
    try {
      final response = await ApiHelper.retryableRequest(() => _dio.put(
            url,
            data: {
              'tankerId': tankerId,
              'status': 'assigned',
            },
          ));

      final norm = ApiHelper.normalizeResponse(response);

      if ((norm['statusCode'] ?? -1) >= 200 && (norm['statusCode'] ?? -1) < 300) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final order = Order.fromJson(data['data']);
        return ServiceResponse(success: true, data: order);
      } else {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ServiceResponse(
          success: false,
          error: data['message'] ?? 'Failed to assign tanker to order',
        );
      }
    } catch (e) {
      developer.log('Error assigning tanker to order: $e', name: 'OrderService');
      return ServiceResponse(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }
}
