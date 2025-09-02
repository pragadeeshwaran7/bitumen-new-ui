import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import 'api_config.dart';
import 'auth_service.dart';
import '../utils/api_helper.dart';

class UserService {
  final AuthService _auth = AuthService();

  Future<ApiResponse<List<dynamic>>> getAllUsers() async {
    try {
      final token = await _auth.getToken();
      if (token == null) return ApiResponse.error('No token');

      final url = ApiConfig.getEndpoint('all-users');
      final dio = ApiHelper.createDio();
      final response = await ApiHelper.retryableRequest(() => dio.get(url, options: Options(headers: ApiConfig.getHeaders(token: token))));
      final norm = ApiHelper.normalizeResponse(response);
      if ((norm['statusCode'] ?? -1) == 200) {
        return ApiResponse.success(norm['data']?['data'] ?? norm['data'] ?? []);
      }
      return ApiResponse.error('Failed to fetch users');
    } catch (e) {
      developer.log('Error fetching users: $e', name: 'UserService');
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<dynamic>> getUserById(String id) async {
    try {
      final token = await _auth.getToken();
      if (token == null) return ApiResponse.error('No token');

      final url = ApiConfig.getEndpoint('user-by-id', pathParams: {'id': id});
      final dio = ApiHelper.createDio();
      final response = await ApiHelper.retryableRequest(() => dio.get(url, options: Options(headers: ApiConfig.getHeaders(token: token))));
      final norm = ApiHelper.normalizeResponse(response);
      if ((norm['statusCode'] ?? -1) == 200) {
        return ApiResponse.success(norm['data']?['data'] ?? norm['data']);
      }
      return ApiResponse.error('Failed to fetch user');
    } catch (e) {
      developer.log('Error fetching user: $e', name: 'UserService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
