import '../models/driver_home_order.dart';
import '../models/driver_payment.dart';
import 'package:mobile_app/shared/models/driver_model.dart';

class DriverHomeApiService {
  static final DriverHomeApiService _instance = DriverHomeApiService._internal();
  factory DriverHomeApiService() => _instance;
  DriverHomeApiService._internal();

  final List<DriverHomeOrder> _mockOrders = [
    DriverHomeOrder(
      orderId: 'ORD2001',
      date: '20 Nov 2023',
      pickup: 'Vashi, Navi Mumbai',
      drop: 'Panvel, Raigad',
      bitumen: 'VG40',
      quantity: '20 Tons',
      distance: '32 km',
      status: 'Pending',
    ),
  ];

  final DriverModel _mockDriver = DriverModel(
    driverId: 'DRV001',
    name: 'Ranjith Kumar',
    phone: '+91 9876543210',
  );

  int _totalKmCovered = 0;

  int get totalKmCovered => _totalKmCovered;

  int get incentive => _totalKmCovered * 1;

  Future<List<DriverHomeOrder>> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockOrders;
  }

  Future<DriverModel> fetchDriverProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDriver;
  }

  void acceptOrder(String orderId) {
    final order = _mockOrders.firstWhere((o) => o.orderId == orderId);
    if (order.status == 'Pending') {
      order.status = 'In Transit';
    }
  }

  void completeOrder(String orderId) {
    final order = _mockOrders.firstWhere((o) => o.orderId == orderId);
    if (order.status == 'In Transit') {
      order.status = 'Completed';
      final kmValue = int.tryParse(order.distance.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      _totalKmCovered += kmValue;
    }
  }

  DriverPayment getPaymentDetails(String driverId) {
    return DriverPayment(
      driverId: driverId,
      kmcovered: _totalKmCovered.toString(),
      incentive: incentive.toString(),
    );
  }

  // TODO: Replace fetchOrders(), acceptOrder(), and getPaymentDetails() with real APIs later
}
