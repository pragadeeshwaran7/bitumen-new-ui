import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../../core/services/api_config.dart';
import '../../../../core/utils/api_helper.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/models/order_model.dart'; // Updated import

class CustomerBookingApiService {
  static final CustomerBookingApiService _instance = CustomerBookingApiService._internal();
  factory CustomerBookingApiService() => _instance;
  CustomerBookingApiService._internal();

  final AuthService _authService = AuthService();
  final Dio _dio = ApiHelper.createDio(); // Added Dio instance

  Future<List<OrderModel>> fetchBookings() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('No authentication token found', name: 'CustomerBookingService');
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
          final bookings = (data['data'] as List)
              .map((bookingJson) => OrderModel.fromJson(bookingJson))
              .toList();
          return bookings;
        }
      }

      developer.log('Failed to fetch bookings: ${norm['text']}', name: 'CustomerBookingService');
      return [];
    } catch (e) {
      developer.log('Error fetching bookings: $e', name: 'CustomerBookingService');
      return [];
    }
  }

  Future<bool> createBooking(OrderModel booking) async { // Changed parameter type
    try {
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('No authentication token found', name: 'CustomerBookingService');
        return false;
      }

      final url = ApiConfig.getEndpoint('create-order');
      final body = booking.toJson(); // Use toJson()
      ApiConfig.logRequest('POST', url, jsonEncode(body));
      
      final response = await ApiHelper.retryableRequest(() => _dio.post(
        url,
        data: body, // Pass as map
        options: Options(headers: ApiConfig.getHeaders(token: token)),
      ));

      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('create-order', norm['statusCode'] ?? -1, norm['text']);

      if ((norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201) {
        developer.log('📦 Order Placed successfully', name: 'CustomerBookingService');
        return true;
      }

      developer.log('Failed to create booking: ${norm['text']}', name: 'CustomerBookingService');
      return false;
    } catch (e) {
      developer.log('Error creating booking: $e', name: 'CustomerBookingService');
      return false;
    }
  }

  Future<bool> updateBookingStatus(String bookingId, String status) async { // Changed method name and parameters
    try {
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('No authentication token found', name: 'CustomerBookingService');
        return false;
      }

      final url = ApiConfig.getEndpoint('update-order-status', pathParams: {'id': bookingId});
      final body = {'status': status}; // Specific body for status update
      ApiConfig.logRequest('PUT', url, jsonEncode(body));
      
      final response = await ApiHelper.retryableRequest(() => _dio.put(
        url,
        data: body, // Pass as map
        options: Options(headers: ApiConfig.getHeaders(token: token)),
      ));

      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('update-order-status', norm['statusCode'] ?? -1, norm['text']);

      return (norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201;
    } catch (e) {
      developer.log('Error updating booking: $e', name: 'CustomerBookingService');
      return false;
    }
  }
}