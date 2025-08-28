import 'dart:io';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class DocumentService {
  final AuthService _auth = AuthService();

  /// Upload a document (multipart) if backend supports /api/documents
  Future<bool> uploadDocument(File file, {required String fieldName, String? docType}) async {
    if (ApiConfig.disableDocumentUpload) {
      developer.log('Document upload is currently disabled via ApiConfig.disableDocumentUpload', name: 'DocumentService');
      return false;
    }
    try {
      final token = await _auth.getToken();
      final url = ApiConfig.getEndpoint('upload-document');
      developer.log('Uploading document to $url', name: 'DocumentService');

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));
      if (docType != null) request.fields['type'] = docType;

      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);
      developer.log('Upload response: ${resp.statusCode} ${resp.body}', name: 'DocumentService');

      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (e) {
      developer.log('Upload failed: $e', name: 'DocumentService');
      return false;
    }
  }
}
