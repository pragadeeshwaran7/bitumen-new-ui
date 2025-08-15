import 'dart:developer';
import '../models/tanker_model.dart';
import 'package:mobile_app/shared/models/supplier_model.dart';

class TankerApiService {
  static final TankerApiService _instance = TankerApiService._internal();
  factory TankerApiService() => _instance;
  TankerApiService._internal();

  final List<Tanker> _mockTankers = [
    Tanker(
      tankerNo: 'MH12AB1234',
      type: 'Steel',
      maxQty: '10 Tons',
      allowedQty: '9.5 Tons',
      rcNo: 'RC1001',
      rcExpiry: '2025-12-31',
      insuranceNo: 'INS9876',
      insuranceExpiry: '2025-06-30',
      status: 'Available',
      driverAssigned: false,
    ),
    Tanker(
      tankerNo: 'MH14XY9876',
      type: 'Bitumen',
      maxQty: '12 Tons',
      allowedQty: '11 Tons',
      rcNo: 'RC2002',
      rcExpiry: '2026-01-15',
      insuranceNo: 'INS1234',
      insuranceExpiry: '2025-09-10',
      status: 'In Transit',
      driverAssigned: true,
      driverName: 'Suresh Rao',
      driverPhone: '9234567890',
    ),
  ];

  Future<void> addTanker(Tanker tanker) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockTankers.add(tanker);
    log("Tanker added (mock): ${tanker.toJson()}");
  }

  List<Tanker> getAllMockTankers() => _mockTankers;

  Future<List<Tanker>> fetchTankers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTankers;
  }

  Future<List<Map<String, String>>> fetchAvailableDrivers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'name': 'Ajay Sharma', 'phone': '9123456789'},
      {'name': 'Suresh Rao', 'phone': '9234567890'},
    ];
  }

  Future<void> assignDriver(String tankerNo, String name, String phone) async {
    final tanker = _mockTankers.firstWhere((t) => t.tankerNo == tankerNo);
    tanker.driverAssigned = true;
    tanker.driverName = name;
    tanker.driverPhone = phone;
  }

  Future<void> updateStatus(String tankerNo, String newStatus) async {
    final tanker = _mockTankers.firstWhere((t) => t.tankerNo == tankerNo);
    tanker.status = newStatus;
  }

  Future<SupplierModel> fetchSupplierProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SupplierModel(supplierId: 'SUP1001', name: 'ABC Suppliers');
  }
}
