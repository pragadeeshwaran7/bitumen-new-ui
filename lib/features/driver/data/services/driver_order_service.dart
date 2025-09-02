import 'dart:io';
import '../models/driver_order.dart';
import 'dart:developer' as developer;

class DriverOrderApiService {
  static final DriverOrderApiService _instance = DriverOrderApiService._internal();
  factory DriverOrderApiService() => _instance;
  DriverOrderApiService._internal();

  Future<DriverOrder?> fetchDriverOrder() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }

  Future<bool> verifyOtp(String type, String otp) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Replace with real API call to verify OTP
    // For now, return false to force real OTP validation
    return false;
  }

  Future<void> uploadBill(File imageFile) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Integrate real API using multipart/form-data
    developer.log("Mock bill uploaded: ${imageFile.path}", name: 'DriverOrderApiService');
  }

  // TODO: Replace fetchDriverOrder, verifyOtp, and uploadBill with real APIs
}
