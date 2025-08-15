//Store all base URLs and endpoint paths here

class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // Auth
  static const String sendOtp = '$baseUrl/send-otp';
  static const String registerCustomer = '$baseUrl/customer/register';
  static const String registerDriver = '$baseUrl/driver/register';
  static const String registerSupplier = '$baseUrl/supplier/register';

  // Orders
  static const String customerOrders = '$baseUrl/customer-orders';
  static const String trackOrder = '$baseUrl/track';
}
