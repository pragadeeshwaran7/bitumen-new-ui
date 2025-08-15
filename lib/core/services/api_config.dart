//import 'package:http/http.dart' as http;

class ApiConfig {
  static const String baseUrl = "http://10.0.2.2:5000/api";
  static const bool useMock = true; // 🔁 change to false when using real backend

  static String getEndpoint(String path) => '$baseUrl/$path';
}
