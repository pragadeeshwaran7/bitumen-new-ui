import '../models/supplier_profile.dart';

class SupplierProfileApiService {
  static final SupplierProfileApiService _instance = SupplierProfileApiService._internal();
  factory SupplierProfileApiService() => _instance;
  SupplierProfileApiService._internal();

  Future<SupplierProfile> fetchSupplierProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return SupplierProfile(
      name: "Suresh",
      company: "ABC Suppliers",
      phone: "9390540800",
      email: "abc_suppliers@example.com",
      address: "Chennai, Tamil Nadu",
    );
  }

  // TODO: Replace with real backend logic
  // Future<SupplierProfile> fetchSupplierProfileFromBackend() async {
  //   final response = await http.get(Uri.parse("https://api.example.com/supplier/profile"));
  //   if (response.statusCode == 200) {
  //     return SupplierProfile.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception("Failed to load profile");
  //   }
  // }
}
