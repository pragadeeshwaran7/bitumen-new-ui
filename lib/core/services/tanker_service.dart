import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../shared/models/tanker_model.dart';
import '../utils/api_helper.dart';
import 'api_config.dart';
import 'auth_service.dart';

class TankerService {
  final AuthService _authService = AuthService();
  final Dio _dio = ApiHelper.createDio(); // Added Dio instance
  
  /// Initialize with auth token
  Future<void> initialize() async {
    final token = await _authService.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Get supplier tankers (scoped to supplier role)
  Future<ApiResponse<List<TankerModel>>> getSupplierTankers() async {
    try {
      
      developer.log('🚛 GETTING SUPPLIER TANKERS', name: 'TankerService');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('supplier-tankers');
      ApiConfig.logRequest('GET', url, null);
      final response = await ApiHelper.retryableRequest(() => _dio.get(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('supplier-tankers', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final List<dynamic> tankersJson = data['data'] ?? [];
        final tankers = tankersJson.map((e) => TankerModel.fromJson(e)).toList();
        return ApiResponse.success(tankers);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to load supplier tankers');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in getSupplierTankers: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Get supplier tanker by ID
  Future<ApiResponse<TankerModel>> getSupplierTankerById(String id) async {
    try {
      
      developer.log('🔍 GETTING SUPPLIER TANKER BY ID: $id', name: 'TankerService');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('supplier-tanker-by-id', pathParams: {'id': id});
      ApiConfig.logRequest('GET', url, null);
      final response = await ApiHelper.retryableRequest(() => _dio.get(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('supplier-tanker-by-id', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        return ApiResponse.success(TankerModel.fromJson(data['data']));
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to load supplier tanker');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in getSupplierTankerById: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Update supplier tanker
  Future<ApiResponse<TankerModel>> updateSupplierTanker(String id, TankerModel tanker) async {
    try {
      
      developer.log('✏️ UPDATING SUPPLIER TANKER: $id', name: 'TankerService');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('update-supplier-tanker', pathParams: {'id': id});
      final body = tanker.toJson(); // Use toJson()
      ApiConfig.logRequest('PUT', url, jsonEncode(body));
      final response = await ApiHelper.retryableRequest(() => _dio.put(
            url,
            data: body, // Pass as map
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('update-supplier-tanker', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final updatedTanker = TankerModel.fromJson(data['data']); // Re-add this line
        developer.log('✅ Tanker updated successfully via API', name: 'TankerService');
        return ApiResponse.success(updatedTanker); // Re-add this line
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to update supplier tanker');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in updateSupplierTanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Delete supplier tanker
  Future<ApiResponse<String>> deleteSupplierTanker(String id) async {
    try {
      
      developer.log('🗑️ DELETING SUPPLIER TANKER: $id', name: 'TankerService');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('delete-supplier-tanker', pathParams: {'id': id});
      ApiConfig.logRequest('DELETE', url, null);
      final response = await ApiHelper.retryableRequest(() => _dio.delete(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('delete-supplier-tanker', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        return ApiResponse.success('Supplier tanker deleted successfully');
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to delete supplier tanker');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in deleteSupplierTanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Assign driver to tanker
  Future<ApiResponse<String>> assignDriver({required String tankerId, required String driverId}) async {
    try {
      developer.log('👷 ASSIGNING DRIVER $driverId TO TANKER $tankerId', name: 'TankerService');
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      final url = ApiConfig.getEndpoint('assign-driver');
      final body = {'tankerId': tankerId, 'driverId': driverId}; // Pass as map
      ApiConfig.logRequest('POST', url, jsonEncode(body));
      final response = await ApiHelper.retryableRequest(() => _dio.post(
            url,
            data: body, // Pass as map
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('assign-driver', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201) {
        return ApiResponse.success('Driver assigned successfully');
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to assign driver');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in assignDriver: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Get all tankers for a supplier
  Future<ApiResponse<List<TankerModel>>> getTankers() async {
    try {
      developer.log('🚛 GETTING ALL TANKERS', name: 'TankerService');
      
      final token = await _authService.getToken();
      if (token == null) {
        developer.log('❌ No authentication token found', name: 'TankerService');
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('tankers');
      developer.log('🌐 Tankers API URL: $url', name: 'TankerService');
      
      ApiConfig.logRequest('GET', url, null);
      
      final response = await ApiHelper.retryableRequest(() => _dio.get(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('tankers', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final List<dynamic> tankersJson = data['data'] ?? [];

        final List<TankerModel> tankers = tankersJson
            .map((json) => TankerModel.fromJson(json))
            .toList();

        developer.log('✅ Tankers loaded from API: ${tankers.length} tankers', name: 'TankerService');
        return ApiResponse.success(tankers);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to get tankers');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in getTankers: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Create new tanker
  Future<ApiResponse<TankerModel>> createTanker(TankerModel tanker) async {
    try {
      developer.log('📝 CREATING NEW TANKER', name: 'TankerService');
      developer.log('🚛 Tanker details: ${jsonEncode(tanker.toJson())}', name: 'TankerService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('create-tanker');
      final body = tanker.toJson(); // Use toJson()
      
      developer.log('🌐 Create Tanker URL: $url', name: 'TankerService');
      developer.log('📤 Request Body: $body', name: 'TankerService');
      
      ApiConfig.logRequest('POST', url, jsonEncode(body));
      
      final response = await ApiHelper.retryableRequest(() => _dio.post(
            url,
            data: body, // Pass as map
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('create-tanker', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 201 || (norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final createdTanker = TankerModel.fromJson(data['data']);
        developer.log('✅ Tanker created successfully via API', name: 'TankerService');
        return ApiResponse.success(createdTanker);
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to create tanker');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in createTanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Update tanker
  Future<ApiResponse<TankerModel>> updateTanker(String tankerId, TankerModel tanker) async {
    try {
      developer.log('✏️ UPDATING TANKER: $tankerId', name: 'TankerService');
      developer.log('🚛 Updated data: ${jsonEncode(tanker.toJson())}', name: 'TankerService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('update-tanker', pathParams: {'id': tankerId});
      final body = tanker.toJson(); // Use toJson()
      
      developer.log('🌐 Update Tanker URL: $url', name: 'TankerService');
      developer.log('📤 Request Body: $body', name: 'TankerService');
      
      ApiConfig.logRequest('PUT', url, jsonEncode(body));
      
      final response = await ApiHelper.retryableRequest(() => _dio.put(
            url,
            data: body, // Pass as map
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('update-tanker', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        final data = norm['data'] ?? (norm['text'].isNotEmpty ? jsonDecode(norm['text']) : null);
        final updatedTanker = TankerModel.fromJson(data['data']); // Re-add this line
        developer.log('✅ Tanker updated successfully via API', name: 'TankerService');
        return ApiResponse.success(updatedTanker); // Re-add this line
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to update tanker');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in updateTanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
  
  /// Delete tanker
  Future<ApiResponse<String>> deleteTanker(String tankerId) async {
    try {
      developer.log('🗑️ DELETING TANKER: $tankerId', name: 'TankerService');
      
      final token = await _authService.getToken();
      if (token == null) {
        return ApiResponse.error('No authentication token found');
      }
      
      final url = ApiConfig.getEndpoint('delete-tanker', pathParams: {'id': tankerId});
      developer.log('🌐 Delete Tanker URL: $url', name: 'TankerService');
      
      ApiConfig.logRequest('DELETE', url, null);
      
      final response = await ApiHelper.retryableRequest(() => _dio.delete(
            url,
            options: Options(headers: ApiConfig.getHeaders(token: token)),
          ));
      final norm = ApiHelper.normalizeResponse(response);
      ApiConfig.logResponse('delete-tanker', norm['statusCode'] ?? -1, norm['text']);
      if ((norm['statusCode'] ?? -1) == 200) {
        return ApiResponse.success('Tanker deleted successfully');
      } else {
        final errorMessage = norm['data'] != null && norm['data']['message'] != null ? norm['data']['message'] : (norm['text'] ?? 'Failed to delete tanker');
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      developer.log('❌ Error in deleteTanker: $e', name: 'TankerService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
