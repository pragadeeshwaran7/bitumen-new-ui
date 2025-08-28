import 'dart:developer' as developer;

class ApiConfig {
  // Backend base URL
  static const String baseUrl = 'https://trucker-backend.onrender.com';
  
  // For development, set this to false to use real API
  static const bool useMock = false; // Always try real API first
  // Temporary feature gates for endpoints that are not available on the backend yet
  // Set to true to disable calling those endpoints from the app to avoid 404s/runtime errors
  static const bool disableDocumentUpload = true;
  static const bool disableSupplierTankers = true;
  static const bool disableProfileEndpoints = false;
  
  // API endpoints
  static const Map<String, String> _endpoints = {
    // Auth endpoints
    'send-otp': '/api/auth/send-otp',
    'login-otp': '/api/auth/login-otp',
    'register-otp': '/api/auth/register-otp',
    
    // User endpoints
  'user-profile': '/api/profile',
  'update-profile': '/api/profile',
  'create-profile': '/api/profile',
  'all-users': '/api/users',
  'upload-document': '/api/documents',
  'user-by-id': '/api/users/{id}',
  'update-user': '/api/users/{id}',
  'delete-user': '/api/users/{id}',
    
    // Driver endpoints
    'drivers': '/api/drivers',
    'driver-by-id': '/api/drivers/{id}',
    'create-driver': '/api/drivers',
    'update-driver': '/api/drivers/{id}',
    'delete-driver': '/api/drivers/{id}',
    'verify-driver': '/api/drivers/send-verification',
    
    // Order endpoints
    'orders': '/api/orders',
    'create-order': '/api/orders',
    'order-by-id': '/api/orders/{id}',
    'all-orders': '/api/orders/all',
    'driver-dashboard': '/api/orders/dashboard/driver',
    'update-order-status': '/api/orders/{id}/status',
    'accept-order': '/api/orders/{id}/accept',
    'cancel-order': '/api/orders/{id}/cancel',
    
    // Payment endpoints
    'payments': '/api/payments/list',
    'create-payment': '/api/payments/order',
    'verify-payment': '/api/payments/verify',
    
    // Tanker endpoints
    'tankers': '/api/tankers',
    'create-tanker': '/api/tankers',
    'tanker-by-id': '/api/tankers/{id}',
    'update-tanker': '/api/tankers/{id}',
    'delete-tanker': '/api/tankers/{id}',
    'supplier-tankers': '/api/supplier/tankers',
    'supplier-tanker-by-id': '/api/supplier/tankers/{id}',
    'update-supplier-tanker': '/api/supplier/tankers/{id}',
    'delete-supplier-tanker': '/api/supplier/tankers/{id}',
    'assign-driver': '/api/tankers/assign-driver',
  };
  
  // Get full endpoint URL
  static String getEndpoint(String key, {Map<String, String>? pathParams}) {
    String endpoint = _endpoints[key] ?? '';
    if (endpoint.isEmpty) {
      print('⚠️ Unknown endpoint key: $key');
      developer.log('⚠️ Unknown endpoint key: $key', name: 'ApiConfig');
      return '$baseUrl/unknown';
    }
    
    // Replace path parameters
    if (pathParams != null) {
      pathParams.forEach((key, value) {
        endpoint = endpoint.replaceAll('{$key}', value);
      });
    }
    
    final fullUrl = '$baseUrl$endpoint';
    print('🌐 API URL: $fullUrl');
    developer.log('🌐 API URL: $fullUrl', name: 'ApiConfig');
    return fullUrl;
  }
  
  // Common headers
  static Map<String, String> getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    print('📋 Headers: $headers');
    return headers;
  }
  
  // Log API response
  static void logResponse(String endpoint, int statusCode, String? body) {
    final message = '📡 API Response: $endpoint\nStatus: $statusCode\nBody: $body';
    print(message);
    developer.log(message, name: 'ApiResponse');
  }
  
  // Log API request
  static void logRequest(String method, String endpoint, String? body) {
    final message = '📤 API Request: $method $endpoint\nBody: $body';
    print(message);
    developer.log(message, name: 'ApiRequest');
  }
}
