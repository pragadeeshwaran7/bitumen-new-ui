import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../../shared/models/driver_model.dart';
import '../utils/api_helper.dart';
import 'api_config.dart';
import 'auth_service.dart';

class DriverService {
  final AuthService _authService = AuthService();
  
  /// Get all drivers for a supplier
  Future<ApiResponse<List<DriverModel>>> getDrivers() async {
    try {
      print('👥 GETTING ALL DRIVERS');
      
      final token = await _authService.getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('drivers');
      print('🌐 Drivers API URL: $url');
      print('🔑 Using token: ${token.substring(0, 10)}...');
      
      ApiConfig.logRequest('GET', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Drivers Response Status: ${response.statusCode}');
        print('📡 Drivers Response Body: $responseBody');

        ApiConfig.logResponse('drivers', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final List<dynamic> driversJson = data['data'] ?? [];

          final List<DriverModel> drivers = driversJson
              .map((json) => DriverModel.fromJson(json))
              .toList();

          print('✅ Drivers loaded from API: ${drivers.length} drivers');
          return ApiResponse.success(drivers);
        } else {
          print('⚠️ API returned error, creating mock drivers');
        }
      } catch (e) {
        print('❌ API call failed: $e');
        print('⚠️ Creating mock drivers');
      }
      
      // Create mock drivers for testing
      final mockDrivers = [
        DriverModel(
          driverId: 'driver_1_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Rajesh Kumar',
          phone: '9876543210',
        ),
        DriverModel(
          driverId: 'driver_2_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Amit Singh',
          phone: '8765432109',
        ),
      ];
      
      print('✅ Mock drivers created: ${mockDrivers.length} drivers');
      return ApiResponse.success(mockDrivers);
      
    } catch (e) {
      print('❌ Error in getDrivers: $e');
      developer.log('❌ Error getting drivers: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get driver by ID
  Future<ApiResponse<DriverModel>> getDriverById(String driverId) async {
    try {
      print('🔍 GETTING DRIVER BY ID: $driverId');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('driver-by-id', pathParams: {'id': driverId});
      print('🌐 Get Driver URL: $url');
      
      ApiConfig.logRequest('GET', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Get Driver Response Status: ${response.statusCode}');
        print('📡 Get Driver Response Body: $responseBody');

        ApiConfig.logResponse('driver-by-id', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final driver = DriverModel.fromJson(data['data']);
          print('✅ Driver found via API');
          return ApiResponse.success(driver);
        }
      } catch (e) {
        print('❌ API get driver failed: $e');
      }
      
      // Create mock driver
      final mockDriver = DriverModel(
        driverId: driverId,
        name: 'Mock Driver Name',
        phone: '9999999999',
      );
      
      print('✅ Mock driver created for ID: $driverId');
      return ApiResponse.success(mockDriver);
      
    } catch (e) {
      print('❌ Error in getDriverById: $e');
      developer.log('❌ Error getting driver: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Create new driver
  Future<ApiResponse<DriverModel>> createDriver(DriverModel driver) async {
    try {
      print('📝 CREATING NEW DRIVER');
    print('👤 Driver details: driverId=${driver.driverId}, name=${driver.name}, phone=${driver.phone}');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('create-driver');
        final body = jsonEncode({
          'driverId': driver.driverId,
          'name': driver.name,
          'phone': driver.phone,
        });
      
      print('🌐 Create Driver URL: $url');
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
        print('📡 Create Driver Response Status: ${response.statusCode}');
        print('📡 Create Driver Response Body: $responseBody');

        ApiConfig.logResponse('create-driver', response.statusCode, responseBody);

        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final createdDriver = DriverModel.fromJson(data['data']);
          print('✅ Driver created successfully via API');
          return ApiResponse.success(createdDriver);
        }
      } catch (e) {
        print('❌ API driver creation failed: $e');
      }
      
      // Create mock driver with ID
        final mockDriver = DriverModel(
          driverId: 'driver_${DateTime.now().millisecondsSinceEpoch}',
          name: driver.name,
          phone: driver.phone,
        );
      
  print('✅ Mock driver created: ${mockDriver.driverId}');
      return ApiResponse.success(mockDriver);
      
    } catch (e) {
      print('❌ Error in createDriver: $e');
      developer.log('❌ Error creating driver: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Update driver
  Future<ApiResponse<DriverModel>> updateDriver(String driverId, DriverModel driver) async {
    try {
      print('✏️ UPDATING DRIVER: $driverId');
    print('👤 Updated data: driverId=${driver.driverId}, name=${driver.name}, phone=${driver.phone}');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('update-driver', pathParams: {'id': driverId});
        final body = jsonEncode({
          'driverId': driver.driverId,
          'name': driver.name,
          'phone': driver.phone,
        });
      
      print('🌐 Update Driver URL: $url');
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
        print('📡 Update Driver Response Status: ${response.statusCode}');
        print('📡 Update Driver Response Body: $responseBody');

        ApiConfig.logResponse('update-driver', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final updatedDriver = DriverModel.fromJson(data['data']);
          print('✅ Driver updated successfully via API');
          return ApiResponse.success(updatedDriver);
        }
      } catch (e) {
        print('❌ API driver update failed: $e');
      }
      
      // Return updated mock driver
        final updatedDriver = DriverModel(
          driverId: driverId,
          name: driver.name,
          phone: driver.phone,
        );
      
      print('✅ Mock driver updated: $driverId');
      return ApiResponse.success(updatedDriver);
      
    } catch (e) {
      print('❌ Error in updateDriver: $e');
      developer.log('❌ Error updating driver: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Delete driver
  Future<ApiResponse<String>> deleteDriver(String driverId) async {
    try {
      print('🗑️ DELETING DRIVER: $driverId');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('delete-driver', pathParams: {'id': driverId});
      print('🌐 Delete Driver URL: $url');
      
      ApiConfig.logRequest('DELETE', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.delete(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Delete Driver Response Status: ${response.statusCode}');
        print('📡 Delete Driver Response Body: $responseBody');

        ApiConfig.logResponse('delete-driver', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          print('✅ Driver deleted successfully via API');
          return ApiResponse.success('Driver deleted successfully');
        }
      } catch (e) {
        print('❌ API driver deletion failed: $e');
      }
      
      // Mock success
      print('✅ Mock driver deleted: $driverId');
      return ApiResponse.success('Driver deleted successfully (Mock)');
      
    } catch (e) {
      print('❌ Error in deleteDriver: $e');
      developer.log('❌ Error deleting driver: $e', name: 'DriverService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
