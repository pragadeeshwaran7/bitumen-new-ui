import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import 'api_config.dart';
import 'auth_service.dart';

class ProfileService {
  final AuthService _auth = AuthService();

  Future<ApiResponse<dynamic>> getProfile() async {
    try {
      final token = await _auth.getToken();
      if (token == null) return ApiResponse.error('No token');

      final url = ApiConfig.getEndpoint('user-profile');
      final resp = await http.get(Uri.parse(url), headers: ApiConfig.getHeaders(token: token));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return ApiResponse.success(data['data']);
      }
      return ApiResponse.error('Failed to fetch profile');
    } catch (e) {
      developer.log('Error fetching profile: $e', name: 'ProfileService');
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<bool>> updateProfile(Map<String, dynamic> payload) async {
    try {
      final token = await _auth.getToken();
      if (token == null) return ApiResponse.error('No token');

      final url = ApiConfig.getEndpoint('update-profile');
      final resp = await http.put(Uri.parse(url), headers: ApiConfig.getHeaders(token: token), body: jsonEncode(payload));
      if (resp.statusCode == 200) {
        return ApiResponse.success(true);
      }
      return ApiResponse.error('Failed to update profile');
    } catch (e) {
      developer.log('Error updating profile: $e', name: 'ProfileService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
