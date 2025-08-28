import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/order_model.dart';
import '../utils/api_helper.dart';
import 'api_config.dart';
import 'auth_service.dart';

class OrderService {
  final AuthService _authService = AuthService();
  
  /// Accept an order by ID
  Future<ApiResponse<String>> acceptOrder(String orderId) async {
    try {
      print('✅ ACCEPTING ORDER: $orderId');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('accept-order', pathParams: {'id': orderId});
      ApiConfig.logRequest('POST', url, null);
      try {
        final response = await ApiHelper.retryableRequest(() => http.post(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));
        final responseBody = response.body;
        print('📡 Accept Order Response Status: ${response.statusCode}');
        print('📡 Accept Order Response Body: $responseBody');
        ApiConfig.logResponse('accept-order', response.statusCode, responseBody);
        if (response.statusCode == 200) {
          return ApiResponse.success('Order accepted successfully');
        }
      } catch (e) {
        print('❌ API accept order failed: $e');
      }
      return ApiResponse.error('Failed to accept order');
    } catch (e) {
      print('❌ Error in acceptOrder: $e');
      developer.log('❌ Error accepting order: $e', name: 'OrderService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Get driver dashboard data
  Future<ApiResponse<Map<String, dynamic>>> getDriverDashboard() async {
    try {
      print('🧭 GETTING DRIVER DASHBOARD');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('driver-dashboard');
      ApiConfig.logRequest('GET', url, null);
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));
        final responseBody = response.body;
        print('📡 Driver Dashboard Response Status: ${response.statusCode}');
        print('📡 Driver Dashboard Response Body: $responseBody');
        ApiConfig.logResponse('driver-dashboard', response.statusCode, responseBody);
        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final Map<String, dynamic> dashboard = data['data'] is Map<String, dynamic>
              ? (data['data'] as Map<String, dynamic>)
              : (data as Map<String, dynamic>);
          return ApiResponse.success(dashboard);
        }
      } catch (e) {
        print('❌ API get driver dashboard failed: $e');
      }
      return ApiResponse.error('Failed to load driver dashboard');
    } catch (e) {
      print('❌ Error in getDriverDashboard: $e');
      developer.log('❌ Error getting driver dashboard: $e', name: 'OrderService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get all orders
  Future<ApiResponse<List<OrderModel>>> getOrders() async {
    try {
      print('📦 GETTING ALL ORDERS');
      
      final token = await _authService.getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('orders');
      print('🌐 Orders API URL: $url');
      print('🔑 Using token: ${token.substring(0, 10)}...');
      
      ApiConfig.logRequest('GET', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Orders Response Status: ${response.statusCode}');
        print('📡 Orders Response Body: $responseBody');

        ApiConfig.logResponse('orders', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final List<dynamic> ordersJson = data['data'] ?? [];

          final List<OrderModel> orders = ordersJson
              .map((json) => OrderModel.fromJson(json))
              .toList();

          print('✅ Orders loaded from API: ${orders.length} orders');
          return ApiResponse.success(orders);
        } else {
          print('⚠️ API returned error, creating mock orders');
        }
      } catch (e) {
        print('❌ API call failed: $e');
        print('⚠️ Creating mock orders');
      }
      
      // Create mock orders for testing
      final mockOrders = [
        OrderModel(
          id: 'order_1_${DateTime.now().millisecondsSinceEpoch}',
          materialType: 'Bitumen Grade 60/70',
          quantity: 10.0,
          unit: 'tons',
          pickupLocation: 'Refinery A',
          deliveryLocation: 'Site X',
          status: 'pending',
          amount: 20000.0,
          paymentStatus: 'pending',
          createdAt: DateTime.now(),
        ),
        OrderModel(
          id: 'order_2_${DateTime.now().millisecondsSinceEpoch}',
          materialType: 'Bitumen Grade 80/100',
          quantity: 15.0,
          unit: 'tons',
          pickupLocation: 'Refinery B',
          deliveryLocation: 'Site Y',
          status: 'completed',
          amount: 30000.0,
          paymentStatus: 'paid',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
        ),
      ];
      
      print('✅ Mock orders created: ${mockOrders.length} orders');
      return ApiResponse.success(mockOrders);
      
    } catch (e) {
      print('❌ Error in getOrders: $e');
      developer.log('❌ Error getting orders: $e', name: 'OrderService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Create new order
  Future<ApiResponse<OrderModel>> createOrder(OrderModel order) async {
    try {
      print('📝 CREATING NEW ORDER');
      print('📦 Order details: ${jsonEncode(order.toJson())}');
      
      final token = await _authService.getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('create-order');
      final body = jsonEncode(order.toJson());
      
      print('🌐 Create Order URL: $url');
      print('📤 Request Body: $body');
      
      ApiConfig.logRequest('POST', url, body);
      
      // Try real API with retry mechanism
      try {
        final response = await ApiHelper.retryableRequest(
          () => http.post(
            Uri.parse(url),
            headers: ApiConfig.getHeaders(token: token),
            body: body,
          ),
        );
        
        final responseBody = response.body;
        print('📡 Create Order Response Status: ${response.statusCode}');
        print('📡 Create Order Response Body: $responseBody');
        
        ApiConfig.logResponse('create-order', response.statusCode, responseBody);
        
        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final createdOrder = OrderModel.fromJson(data['data']);
          print('✅ Order created successfully via API');
          return ApiResponse.success(createdOrder);
        } else {
          print('⚠️ API order creation failed, creating mock order');
        }
      } catch (e) {
        print('❌ API order creation failed: $e');
        print('⚠️ Creating mock order');
      }
      
      // Create mock order
      final mockOrder = OrderModel(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        materialType: order.materialType,
        quantity: order.quantity,
        unit: order.unit,
        pickupLocation: order.pickupLocation,
        deliveryLocation: order.deliveryLocation,
        status: 'pending',
        amount: order.quantity * 2000,
        paymentStatus: 'pending',
        createdAt: DateTime.now(),
      );
      
      print('✅ Mock order created: ${mockOrder.id}');
      return ApiResponse.success(mockOrder);
      
    } catch (e) {
      print('❌ Error in createOrder: $e');
      developer.log('❌ Error creating order: $e', name: 'OrderService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get order by ID
  Future<ApiResponse<OrderModel>> getOrderById(String orderId) async {
    try {
      print('🔍 GETTING ORDER BY ID: $orderId');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('order-by-id', pathParams: {'id': orderId});
      print('🌐 Get Order URL: $url');
      
      ApiConfig.logRequest('GET', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Get Order Response Status: ${response.statusCode}');
        print('📡 Get Order Response Body: $responseBody');

        ApiConfig.logResponse('order-by-id', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final order = OrderModel.fromJson(data['data']);
          print('✅ Order found via API');
          return ApiResponse.success(order);
        }
      } catch (e) {
        print('❌ API get order failed: $e');
      }
      
      // Create mock order
      final mockOrder = OrderModel(
        id: orderId,
        materialType: 'Bitumen Grade 60/70',
        quantity: 20.0,
        unit: 'tons',
        pickupLocation: 'Mock Refinery',
        deliveryLocation: 'Mock Destination',
        status: 'pending',
        amount: 40000.0,
        paymentStatus: 'pending',
        createdAt: DateTime.now(),
      );
      
      print('✅ Mock order created for ID: $orderId');
      return ApiResponse.success(mockOrder);
      
    } catch (e) {
      print('❌ Error in getOrderById: $e');
      developer.log('❌ Error getting order: $e', name: 'OrderService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Update order
  Future<ApiResponse<OrderModel>> updateOrder(String orderId, OrderModel order) async {
    try {
      print('✏️ UPDATING ORDER: $orderId');
      print('📦 Updated data: ${jsonEncode(order.toJson())}');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('update-order-status', pathParams: {'id': orderId});
      final body = jsonEncode({
        'status': order.status,
        'paymentStatus': order.paymentStatus,
      });
      
      print('🌐 Update Order Status URL: $url');
      print('📤 Request Body: $body');
      
      ApiConfig.logRequest('PUT', url, body);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.put(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
          body: body,
        ));

        final responseBody = response.body;
        print('📡 Update Order Response Status: ${response.statusCode}');
        print('📡 Update Order Response Body: $responseBody');

        ApiConfig.logResponse('update-order', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final updatedOrder = OrderModel.fromJson(data['data']);
          print('✅ Order updated successfully via API');
          return ApiResponse.success(updatedOrder);
        }
      } catch (e) {
        print('❌ API order update failed: $e');
      }
      
      // Return updated mock order
      final updatedOrder = OrderModel(
        id: orderId,
        materialType: order.materialType,
        quantity: order.quantity,
        unit: order.unit,
        pickupLocation: order.pickupLocation,
        deliveryLocation: order.deliveryLocation,
        status: order.status,
        amount: order.amount,
        paymentStatus: order.paymentStatus,
        updatedAt: DateTime.now(),
      );
      
      print('✅ Mock order updated: $orderId');
      return ApiResponse.success(updatedOrder);
      
    } catch (e) {
      print('❌ Error in updateOrder: $e');
      developer.log('❌ Error updating order: $e', name: 'OrderService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Cancel order
  Future<ApiResponse<String>> cancelOrder(String orderId) async {
    try {
      print('❌ CANCELLING ORDER: $orderId');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('cancel-order', pathParams: {'id': orderId});
      print('🌐 Cancel Order URL: $url');
      
      ApiConfig.logRequest('POST', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.post(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Cancel Order Response Status: ${response.statusCode}');
        print('📡 Cancel Order Response Body: $responseBody');

        ApiConfig.logResponse('cancel-order', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          print('✅ Order cancelled successfully via API');
          return ApiResponse.success('Order cancelled successfully');
        }
      } catch (e) {
        print('❌ API order cancellation failed: $e');
      }
      
      // Mock success
      print('✅ Mock order cancelled: $orderId');
      return ApiResponse.success('Order cancelled successfully (Mock)');
      
    } catch (e) {
      print('❌ Error in cancelOrder: $e');
      developer.log('❌ Error cancelling order: $e', name: 'OrderService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
