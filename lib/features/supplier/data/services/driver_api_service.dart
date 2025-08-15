import 'dart:developer';
import 'dart:io';
import '../models/driver_model.dart';

class DriverApiService {
  static final DriverApiService _instance = DriverApiService._internal();
  factory DriverApiService() => _instance;
  DriverApiService._internal();

  final List<Driver> _mockDrivers = [];

  Future<void> addDriver({
    required Driver driver,
    required File? licenseFile,
    required File? aadharFile,
  }) async {
    // Simulate file handling
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDrivers.add(driver);
    log("Driver added (mock): ${driver.toJson()}");
  }

  List<Driver> getAllDrivers() => _mockDrivers;

  // ✅ Replace this in future:
  // Future<void> addDriverWithBackend(...) => call HTTP POST API
}
