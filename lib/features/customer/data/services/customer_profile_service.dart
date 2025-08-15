import '../models/customer_profile.dart';

class CustomerProfileApiService {
  static final CustomerProfileApiService _instance = CustomerProfileApiService._internal();
  factory CustomerProfileApiService() => _instance;
  CustomerProfileApiService._internal();

  Future<CustomerProfile> fetchCustomerProfile() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate network delay
    return CustomerProfile(
      name: "John Doe",
      company: "ABC Logistics",
      phone: "9390540800",
      email: "john.doe@example.com",
      address: "Mumbai, Maharashtra",
    );
  }

  // TODO: Later integrate with real backend API
  // Future<CustomerProfile> fetchCustomerProfileFromBackend() async {
  //   final response = await http.get(Uri.parse("https://api.example.com/customer/profile"));
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     return CustomerProfile.fromJson(json);
  //   } else {
  //     throw Exception("Failed to load profile");
  //   }
  // }
}
