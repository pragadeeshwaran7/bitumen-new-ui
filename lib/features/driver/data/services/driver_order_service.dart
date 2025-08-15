import 'dart:io';
import '../models/driver_order.dart';
import 'driver_home_service.dart';

class DriverOrderApiService {
  static final DriverOrderApiService _instance = DriverOrderApiService._internal();
  factory DriverOrderApiService() => _instance;
  DriverOrderApiService._internal();

  final DriverOrder _mockOrder = DriverOrder(
    orderId: "ORD2001",
    customerName: "Amit Sharma",
    customerPhone: "+91 98765 43210",
    pickupLocation: "Vashi, Navi Mumbai",
    pickupAddress: "Chandivali, Powai, Mumbai - 400072",
    dropLocation: "Panvel, Raigad",
    dropAddress: "MIDC Phase 2, Dombivli East, Thane - 421204",
    bitumenType: "VG40",
    quantityLoading: "20 Tons",
    quantityUnloading: "20 Tons",
    distance: "32 km",
    status: "In Transit",
  );

  Future<DriverOrder?> fetchDriverOrder() async {
  await Future.delayed(const Duration(milliseconds: 500));
  return _mockOrder.status == 'Completed' ? null : _mockOrder;
}

  Future<bool> verifyOtp(String type, String otp) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return (type == 'pickup' && otp == '1234') || (type == 'drop' && otp == '5678');
  }

  Future<void> uploadBill(File imageFile) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Integrate real API using multipart/form-data
    print("Mock bill uploaded: ${imageFile.path}");
  }

  Future<void> completeDriverOrder(String orderId) async {
  await Future.delayed(const Duration(milliseconds: 300));
  DriverHomeApiService().completeOrder(orderId);
  _mockOrder.status = "Completed"; // <- Update order status here
}

  // TODO: Replace fetchDriverOrder, verifyOtp, and uploadBill with real APIs
}
