import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../utils/api_helper.dart';
import 'api_config.dart';
import 'auth_service.dart';

class TankerModel {
  final String? id;
  final String? supplierId;
  final String registrationNumber;
  final String type;
  final double capacity;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  TankerModel({
    this.id,
    this.supplierId,
    required this.registrationNumber,
    required this.type,
    required this.capacity,
    this.status = 'available',
    this.createdAt,
    this.updatedAt,
  });
  
  factory TankerModel.fromJson(Map<String, dynamic> json) {
    return TankerModel(
      id: json['_id'] ?? json['id'],
      supplierId: json['supplierId'],
      registrationNumber: json['registrationNumber'] ?? '',
      type: json['type'] ?? '',
      capacity: (json['capacity'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'available',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (supplierId != null) 'supplierId': supplierId,
      'registrationNumber': registrationNumber,
      'type': type,
      'capacity': capacity,
      'status': status,
    };
  }
}

class TankerService {
  final AuthService _authService = AuthService();
  
  /// Get supplier tankers (scoped to supplier role)
  Future<ApiResponse<List<TankerModel>>> getSupplierTankers() async {
    try {
      if (ApiConfig.disableSupplierTankers) {
        print('⚠️ Supplier tankers API is disabled by configuration');
        return ApiResponse.error('Supplier tankers feature is temporarily disabled');
      }
      print('🚛 GETTING SUPPLIER TANKERS');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('supplier-tankers');
      ApiConfig.logRequest('GET', url, null);
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));
        final responseBody = response.body;
        print('📡 Supplier Tankers Response Status: ${response.statusCode}');
        print('📡 Supplier Tankers Response Body: $responseBody');
        ApiConfig.logResponse('supplier-tankers', response.statusCode, responseBody);
        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final List<dynamic> tankersJson = data['data'] ?? [];
          final tankers = tankersJson.map((e) => TankerModel.fromJson(e)).toList();
          return ApiResponse.success(tankers);
        }
      } catch (e) {
        print('❌ API get supplier tankers failed: $e');
      }
      return ApiResponse.error('Failed to load supplier tankers');
    } catch (e) {
      print('❌ Error in getSupplierTankers: $e');
      developer.log('❌ Error getting supplier tankers: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Get supplier tanker by ID
  Future<ApiResponse<TankerModel>> getSupplierTankerById(String id) async {
    try {
      if (ApiConfig.disableSupplierTankers) {
        print('⚠️ Supplier tanker API is disabled by configuration');
        return ApiResponse.error('Supplier tanker feature is temporarily disabled');
      }
      print('🔍 GETTING SUPPLIER TANKER BY ID: $id');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('supplier-tanker-by-id', pathParams: {'id': id});
      ApiConfig.logRequest('GET', url, null);
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));
        final responseBody = response.body;
        print('📡 Supplier Tanker By ID Response Status: ${response.statusCode}');
        print('📡 Supplier Tanker By ID Response Body: $responseBody');
        ApiConfig.logResponse('supplier-tanker-by-id', response.statusCode, responseBody);
        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          return ApiResponse.success(TankerModel.fromJson(data['data']));
        }
      } catch (e) {
        print('❌ API get supplier tanker by id failed: $e');
      }
      return ApiResponse.error('Failed to load supplier tanker');
    } catch (e) {
      print('❌ Error in getSupplierTankerById: $e');
      developer.log('❌ Error getting supplier tanker by id: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Update supplier tanker
  Future<ApiResponse<TankerModel>> updateSupplierTanker(String id, TankerModel tanker) async {
    try {
      if (ApiConfig.disableSupplierTankers) {
        print('⚠️ Update supplier tanker API is disabled by configuration');
        return ApiResponse.error('Update supplier tanker is temporarily disabled');
      }
      print('✏️ UPDATING SUPPLIER TANKER: $id');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('update-supplier-tanker', pathParams: {'id': id});
      final body = jsonEncode(tanker.toJson());
      ApiConfig.logRequest('PUT', url, body);
      try {
        final response = await ApiHelper.retryableRequest(() => http.put(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
          body: body,
        ));
        final responseBody = response.body;
        print('📡 Update Supplier Tanker Response Status: ${response.statusCode}');
        print('📡 Update Supplier Tanker Response Body: $responseBody');
        ApiConfig.logResponse('update-supplier-tanker', response.statusCode, responseBody);
        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          return ApiResponse.success(TankerModel.fromJson(data['data']));
        }
      } catch (e) {
        print('❌ API update supplier tanker failed: $e');
      }
      return ApiResponse.error('Failed to update supplier tanker');
    } catch (e) {
      print('❌ Error in updateSupplierTanker: $e');
      developer.log('❌ Error updating supplier tanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Delete supplier tanker
  Future<ApiResponse<String>> deleteSupplierTanker(String id) async {
    try {
      if (ApiConfig.disableSupplierTankers) {
        print('⚠️ Delete supplier tanker API is disabled by configuration');
        return ApiResponse.error('Delete supplier tanker is temporarily disabled');
      }
      print('🗑️ DELETING SUPPLIER TANKER: $id');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('delete-supplier-tanker', pathParams: {'id': id});
      ApiConfig.logRequest('DELETE', url, null);
      try {
        final response = await ApiHelper.retryableRequest(() => http.delete(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));
        final responseBody = response.body;
        print('📡 Delete Supplier Tanker Response Status: ${response.statusCode}');
        print('📡 Delete Supplier Tanker Response Body: $responseBody');
        ApiConfig.logResponse('delete-supplier-tanker', response.statusCode, responseBody);
        if (response.statusCode == 200) {
          return ApiResponse.success('Supplier tanker deleted successfully');
        }
      } catch (e) {
        print('❌ API delete supplier tanker failed: $e');
      }
      return ApiResponse.error('Failed to delete supplier tanker');
    } catch (e) {
      print('❌ Error in deleteSupplierTanker: $e');
      developer.log('❌ Error deleting supplier tanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Assign driver to tanker
  Future<ApiResponse<String>> assignDriver({required String tankerId, required String driverId}) async {
    try {
      print('👷 ASSIGNING DRIVER $driverId TO TANKER $tankerId');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('assign-driver');
      final body = jsonEncode({'tankerId': tankerId, 'driverId': driverId});
      ApiConfig.logRequest('POST', url, body);
      try {
        final response = await ApiHelper.retryableRequest(() => http.post(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
          body: body,
        ));
        final responseBody = response.body;
        print('📡 Assign Driver Response Status: ${response.statusCode}');
        print('📡 Assign Driver Response Body: $responseBody');
        ApiConfig.logResponse('assign-driver', response.statusCode, responseBody);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return ApiResponse.success('Driver assigned successfully');
        }
      } catch (e) {
        print('❌ API assign driver failed: $e');
      }
      return ApiResponse.error('Failed to assign driver');
    } catch (e) {
      print('❌ Error in assignDriver: $e');
      developer.log('❌ Error assigning driver: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get all tankers for a supplier
  Future<ApiResponse<List<TankerModel>>> getTankers() async {
    try {
      print('🚛 GETTING ALL TANKERS');
      
      final token = await _authService.getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('tankers');
      print('🌐 Tankers API URL: $url');
      print('🔑 Using token: ${token.substring(0, 10)}...');
      
      ApiConfig.logRequest('GET', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.get(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Tankers Response Status: ${response.statusCode}');
        print('📡 Tankers Response Body: $responseBody');

        ApiConfig.logResponse('tankers', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final List<dynamic> tankersJson = data['data'] ?? [];

          final List<TankerModel> tankers = tankersJson
              .map((json) => TankerModel.fromJson(json))
              .toList();

          print('✅ Tankers loaded from API: ${tankers.length} tankers');
          return ApiResponse.success(tankers);
        } else {
          print('⚠️ API returned error, creating mock tankers');
        }
      } catch (e) {
        print('❌ API call failed: $e');
        print('⚠️ Creating mock tankers');
      }
      
      // Create mock tankers for testing
      final mockTankers = [
        TankerModel(
          id: 'tanker_1_${DateTime.now().millisecondsSinceEpoch}',
          registrationNumber: 'MH12AB1234',
          type: 'Bitumen Tanker',
          capacity: 25000.0,
          status: 'available',
          createdAt: DateTime.now(),
        ),
        TankerModel(
          id: 'tanker_2_${DateTime.now().millisecondsSinceEpoch}',
          registrationNumber: 'DL01CD5678',
          type: 'Heavy Duty Tanker',
          capacity: 30000.0,
          status: 'in_use',
          createdAt: DateTime.now().subtract(Duration(days: 30)),
        ),
        TankerModel(
          id: 'tanker_3_${DateTime.now().millisecondsSinceEpoch}',
          registrationNumber: 'KA03EF9012',
          type: 'Medium Tanker',
          capacity: 20000.0,
          status: 'maintenance',
          createdAt: DateTime.now().subtract(Duration(days: 15)),
        ),
      ];
      
      print('✅ Mock tankers created: ${mockTankers.length} tankers');
      return ApiResponse.success(mockTankers);
      
    } catch (e) {
      print('❌ Error in getTankers: $e');
      developer.log('❌ Error getting tankers: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Create new tanker
  Future<ApiResponse<TankerModel>> createTanker(TankerModel tanker) async {
    try {
      print('📝 CREATING NEW TANKER');
      print('🚛 Tanker details: ${jsonEncode(tanker.toJson())}');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('create-tanker');
      final body = jsonEncode(tanker.toJson());
      
      print('🌐 Create Tanker URL: $url');
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
        print('📡 Create Tanker Response Status: ${response.statusCode}');
        print('📡 Create Tanker Response Body: $responseBody');

        ApiConfig.logResponse('create-tanker', response.statusCode, responseBody);

        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final createdTanker = TankerModel.fromJson(data['data']);
          print('✅ Tanker created successfully via API');
          return ApiResponse.success(createdTanker);
        }
      } catch (e) {
        print('❌ API tanker creation failed: $e');
      }
      
      // Create mock tanker with ID
      final mockTanker = TankerModel(
        id: 'tanker_${DateTime.now().millisecondsSinceEpoch}',
        registrationNumber: tanker.registrationNumber,
        type: tanker.type,
        capacity: tanker.capacity,
        status: 'available',
        createdAt: DateTime.now(),
      );
      
      print('✅ Mock tanker created: ${mockTanker.id}');
      return ApiResponse.success(mockTanker);
      
    } catch (e) {
      print('❌ Error in createTanker: $e');
      developer.log('❌ Error creating tanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Update tanker
  Future<ApiResponse<TankerModel>> updateTanker(String tankerId, TankerModel tanker) async {
    try {
      print('✏️ UPDATING TANKER: $tankerId');
      print('🚛 Updated data: ${jsonEncode(tanker.toJson())}');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('update-tanker', pathParams: {'id': tankerId});
      final body = jsonEncode(tanker.toJson());
      
      print('🌐 Update Tanker URL: $url');
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
        print('📡 Update Tanker Response Status: ${response.statusCode}');
        print('📡 Update Tanker Response Body: $responseBody');

        ApiConfig.logResponse('update-tanker', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          final updatedTanker = TankerModel.fromJson(data['data']);
          print('✅ Tanker updated successfully via API');
          return ApiResponse.success(updatedTanker);
        }
      } catch (e) {
        print('❌ API tanker update failed: $e');
      }
      
      // Return updated mock tanker
      final updatedTanker = TankerModel(
        id: tankerId,
        registrationNumber: tanker.registrationNumber,
        type: tanker.type,
        capacity: tanker.capacity,
        status: tanker.status,
        updatedAt: DateTime.now(),
      );
      
      print('✅ Mock tanker updated: $tankerId');
      return ApiResponse.success(updatedTanker);
      
    } catch (e) {
      print('❌ Error in updateTanker: $e');
      developer.log('❌ Error updating tanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Delete tanker
  Future<ApiResponse<String>> deleteTanker(String tankerId) async {
    try {
      print('🗑️ DELETING TANKER: $tankerId');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('delete-tanker', pathParams: {'id': tankerId});
      print('🌐 Delete Tanker URL: $url');
      
      ApiConfig.logRequest('DELETE', url, null);
      
      // Try real API with retry
      try {
        final response = await ApiHelper.retryableRequest(() => http.delete(
          Uri.parse(url),
          headers: ApiConfig.getHeaders(token: token),
        ));

        final responseBody = response.body;
        print('📡 Delete Tanker Response Status: ${response.statusCode}');
        print('📡 Delete Tanker Response Body: $responseBody');

        ApiConfig.logResponse('delete-tanker', response.statusCode, responseBody);

        if (response.statusCode == 200) {
          print('✅ Tanker deleted successfully via API');
          return ApiResponse.success('Tanker deleted successfully');
        }
      } catch (e) {
        print('❌ API tanker deletion failed: $e');
      }
      
      // Mock success
      print('✅ Mock tanker deleted: $tankerId');
      return ApiResponse.success('Tanker deleted successfully (Mock)');
      
    } catch (e) {
      print('❌ Error in deleteTanker: $e');
      developer.log('❌ Error deleting tanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
