import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import 'api_config.dart';
import 'auth_service.dart';

class UserService {
  final AuthService _auth = AuthService();

  Future<ApiResponse<List<dynamic>>> getAllUsers() async {
    try {
      final token = await _auth.getToken();
      if (token == null) return ApiResponse.error('No token');

      final url = ApiConfig.getEndpoint('all-users');
      final resp = await http.get(Uri.parse(url), headers: ApiConfig.getHeaders(token: token));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return ApiResponse.success(data['data'] ?? []);
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
      final resp = await http.get(Uri.parse(url), headers: ApiConfig.getHeaders(token: token));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return ApiResponse.success(data['data']);
      }
      return ApiResponse.error('Failed to fetch user');
    } catch (e) {
      developer.log('Error fetching user: $e', name: 'UserService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
