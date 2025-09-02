import 'dart:io';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'api_config.dart';
import 'auth_service.dart';
import '../utils/api_helper.dart';

class DocumentService {
  final AuthService _auth = AuthService();

  /// Upload a document (multipart) if backend supports /api/documents
  Future<bool> uploadDocument(File file, {required String fieldName, String? docType}) async {
    
    try {
      final token = await _auth.getToken();
      final url = ApiConfig.getEndpoint('upload-document');
      developer.log('Uploading document to $url', name: 'DocumentService');

      final dio = ApiHelper.createDio();
      final form = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path, filename: file.path.split(Platform.pathSeparator).last),
        if (docType != null) 'type': docType,
      });

      final response = await ApiHelper.retryableRequest(() => dio.post(
            url,
            data: form,
            options: Options(
              headers: {
                'Accept': 'application/json',
                if (token != null) 'Authorization': 'Bearer $token',
                // Dio will set Content-Type for multipart
              },
            ),
          ));

      final norm = ApiHelper.normalizeResponse(response);
      developer.log('Upload response: ${norm['statusCode']} ${norm['text']}', name: 'DocumentService');
      return (norm['statusCode'] ?? -1) == 200 || (norm['statusCode'] ?? -1) == 201;
    } catch (e) {
      developer.log('Upload failed: $e', name: 'DocumentService');
      return false;
    }
  }
}
