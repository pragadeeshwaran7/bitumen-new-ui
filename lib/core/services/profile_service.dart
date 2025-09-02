import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import 'api_config.dart';
import 'auth_service.dart';
import 'permission_service.dart';
import '../utils/api_helper.dart';

class ProfileService {
  final AuthService _auth = AuthService();
  final Dio _dio = ApiHelper.createDio();
  
  /// Initialize with auth token
  Future<void> initialize() async {
    final token = await _auth.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<ApiResponse<User>> getProfile() async {
    try {
      final token = await _auth.getToken();
      if (token == null) return ApiResponse.error('No token');

      final url = ApiConfig.getEndpoint('user-profile');
      final response = await ApiHelper.retryableRequest(
        () => _dio.get(
          url,
          options: Options(headers: ApiConfig.getHeaders(token: token)),
        ),
      );

      final norm = ApiHelper.normalizeResponse(response);
      if ((norm['statusCode'] ?? -1) == 200) {
        final userData = norm['data']?['data'] ?? norm['data'];
        if (userData != null) {
          return ApiResponse.success(User.fromJson(userData));
        }
      }
      return ApiResponse.error('Failed to fetch profile');
    } catch (e) {
      developer.log('Error fetching profile: $e', name: 'ProfileService');
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<User>> updateProfile(User user) async {
    try {
      final token = await _auth.getToken();
      if (token == null) return ApiResponse.error('No token');

      // Request location permission if not already granted
      final hasLocationPermission = await PermissionService.requestLocationPermission();
      if (hasLocationPermission) {
        try {
          final position = await Geolocator.getCurrentPosition();
          user = user.copyWith(
            location: {
              'type': 'Point',
              'coordinates': [position.longitude, position.latitude],
              'address': user.location?['address'],
            },
          );
        } catch (e) {
          developer.log('Error getting location: $e', name: 'ProfileService');
        }
      }

      final url = ApiConfig.getEndpoint('update-profile');
      final response = await ApiHelper.retryableRequest(
        () => _dio.put(
          url,
          data: user.toJson(),
          options: Options(headers: ApiConfig.getHeaders(token: token)),
        ),
      );

      final norm = ApiHelper.normalizeResponse(response);
      if ((norm['statusCode'] ?? -1) == 200) {
        final userData = norm['data']?['data'] ?? norm['data'];
        if (userData != null) {
          return ApiResponse.success(User.fromJson(userData));
        }
      }
      return ApiResponse.error('Failed to update profile');
    } catch (e) {
      developer.log('Error updating profile: $e', name: 'ProfileService');
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<bool>> uploadDocument(String filePath, String documentType) async {
    try {
      final token = await _auth.getToken();
      if (token == null) return ApiResponse.error('No token');

      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(filePath),
        'type': documentType,
      });

      final url = ApiConfig.getEndpoint('upload-document');
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            ...ApiConfig.getHeaders(token: token),
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final norm = ApiHelper.normalizeResponse(response);
      if ((norm['statusCode'] ?? -1) == 200) {
        return ApiResponse.success(true);
      }
      return ApiResponse.error('Failed to upload document');
    } catch (e) {
      developer.log('Error uploading document: $e', name: 'ProfileService');
      return ApiResponse.error('Network error: $e');
    }
  }
}
