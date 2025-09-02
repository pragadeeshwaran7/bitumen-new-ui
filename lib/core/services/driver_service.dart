import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../../shared/models/driver_model.dart';
import '../utils/api_helper.dart';
import 'api_config.dart';
import 'auth_service.dart';

class DriverService {
  final AuthService _authService = AuthService();
  final Dio _dio = ApiHelper.createDio();
  
  // Initialize with auth token
  Future<void> initialize() async {
    final token = await _authService.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Get all drivers for a supplier
  Future<ApiResponse<List<DriverModel>>> getDrivers() async {
    try {
      developer.log('👥 GETTING ALL DRIVERS', name: 'DriverService');
      
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('❌ No authentication token found', name: 'DriverService');
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('drivers');
      developer.log('🌐 Drivers API URL: $url', name: 'DriverService');
      
      ApiConfig.logRequest('GET', url, null);
      
      final response = await ApiHelper.retryableRequest(() => _dio.get(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('drivers', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final List<dynamic> driversJson = data['data'] ?? [];

        final List<DriverModel> drivers = driversJson
            .map((json) => DriverModel.fromJson(json))
            .toList();

        developer.log('✅ Drivers loaded from API: ${drivers.length} drivers', name: 'DriverService');
        return ApiResponse.success(drivers);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to get drivers');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in getDrivers: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get driver by ID
  Future<ApiResponse<DriverModel>> getDriverById(String driverId) async {
    try {
      developer.log('🔍 GETTING DRIVER BY ID: $driverId', name: 'DriverService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('driver-by-id', pathParams: {'id': driverId});
      developer.log('🌐 Get Driver URL: $url', name: 'DriverService');
      
      ApiConfig.logRequest('GET', url, null);
      
      final response = await ApiHelper.retryableRequest(() => _dio.get(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('driver-by-id', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final driver = DriverModel.fromJson(data['data']);
        developer.log('✅ Driver found via API', name: 'DriverService');
        return ApiResponse.success(driver);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to get driver');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in getDriverById: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Create new driver
  Future<ApiResponse<DriverModel>> createDriver(DriverModel driver) async {
    try {
      developer.log('📝 CREATING NEW DRIVER', name: 'DriverService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('create-driver');
      final body = driver.toJson();
      
      developer.log('🌐 Create Driver URL: $url', name: 'DriverService');
      developer.log('📤 Request Body: $body', name: 'DriverService');
      
      ApiConfig.logRequest('POST', url, jsonEncode(body));
      
      final response = await ApiHelper.retryableRequest(() => _dio.post(
            url,
            data: body,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('create-driver', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 201 || (norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final createdDriver = DriverModel.fromJson(data['data']);
        developer.log('✅ Driver created successfully via API', name: 'DriverService');
        return ApiResponse.success(createdDriver);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to create driver');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in createDriver: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Update driver
  Future<ApiResponse<DriverModel>> updateDriver(String driverId, DriverModel driver) async {
    try {
      developer.log('✏️ UPDATING DRIVER: $driverId', name: 'DriverService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('update-driver', pathParams: {'id': driverId});
      final body = driver.toJson();
      
      developer.log('🌐 Update Driver URL: $url', name: 'DriverService');
      developer.log('📤 Request Body: $body', name: 'DriverService');
      
      ApiConfig.logRequest('PUT', url, jsonEncode(body));
      
      final response = await ApiHelper.retryableRequest(() => _dio.put(
            url,
            data: body,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('update-driver', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final updatedDriver = DriverModel.fromJson(data['data']);
        developer.log('✅ Driver updated successfully via API', name: 'DriverService');
        return ApiResponse.success(updatedDriver);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to update driver');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in updateDriver: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Delete driver
  Future<ApiResponse<String>> deleteDriver(String driverId) async {
    try {
      developer.log('🗑️ DELETING DRIVER: $driverId', name: 'DriverService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('delete-driver', pathParams: {'id': driverId});
      developer.log('🌐 Delete Driver URL: $url', name: 'DriverService');
      
      ApiConfig.logRequest('DELETE', url, null);
      
      final response = await ApiHelper.retryableRequest(() => _dio.delete(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('delete-driver', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        developer.log('✅ Driver deleted successfully via API', name: 'DriverService');
        return ApiResponse.success('Driver deleted successfully');
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to delete driver');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in deleteDriver: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
}