import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'api_config.dart';

class AuthService {
  Future<bool> sendOtp({required String method, required String value}) async {
    if (ApiConfig.useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    }

    final uri = Uri.parse(ApiConfig.getEndpoint('$method/send-otp'));
    final response = await http.post(uri, body: {method: value});
    return response.statusCode == 200;
  }

  Future<bool> verifyOtp({required String method, required String value, required String otp}) async {
    if (ApiConfig.useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      return otp == '1234'; // mock condition
    }

    final uri = Uri.parse(ApiConfig.getEndpoint('$method/verify-otp'));
    final response = await http.post(uri, body: {method: value, 'otp': otp});
    return response.statusCode == 200;
  }

  Future<bool> registerCustomer({
    required String name,
    required String phone,
    required String email,
    required String gstNumber,
    required File? gstFile,
  }) async {
    if (ApiConfig.useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }

    final url = Uri.parse(ApiConfig.getEndpoint('customer/register'));
    final request = http.MultipartRequest('POST', url);

    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['gstNumber'] = gstNumber;

    if (gstFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'gstFile',
        gstFile.path,
        filename: path.basename(gstFile.path),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response.statusCode == 201;
  
  }

  Future<bool> registerSupplier(Map<String, String> data,) async {
    if (ApiConfig.useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }

    final url = Uri.parse(ApiConfig.getEndpoint('supplier/register'));
    final response = await http.post(url, body: data);
    return response.statusCode == 201;
  }
}
