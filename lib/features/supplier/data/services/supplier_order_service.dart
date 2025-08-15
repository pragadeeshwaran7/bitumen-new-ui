import 'dart:async';
import '../models/supplier_order.dart';

class SupplierOrderApiService {
  static final SupplierOrderApiService _instance =
      SupplierOrderApiService._internal();
  factory SupplierOrderApiService() => _instance;
  SupplierOrderApiService._internal();

  final List<SupplierOrder> _mockOrders = [
    SupplierOrder(
      orderId: "TR123456789",
      date: "2025-02-15",
      pickup: "Mumbai, Maharashtra",
      delivery: "Pune, Maharashtra",
      truckNo: "MH12AB1234",
      amount: "₹12,500",
      status: "In Transit",
      driverName: "Ravi Kumar",
      driverPhone: "+91 9876543210",
    ),
    SupplierOrder(
      orderId: "TR987654321",
      date: "2025-02-18",
      pickup: "Delhi, Delhi",
      delivery: "Jaipur, Rajasthan",
      truckNo: "MH12AB1234",
      amount: "₹18,750",
      status: "Completed",
      driverName: "Ajay Sharma",
      driverPhone: "+91 9123456789",
    ),
  ];

  Future<List<SupplierOrder>> fetchOrders({String filter = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (filter == 'All') return _mockOrders;
    return _mockOrders.where((o) => o.status == filter).toList();
  }

  // TODO: Replace this with real API
  // Future<List<SupplierOrder>> fetchOrdersFromBackend(String filter) async {
  //   final response = await http.get(Uri.parse("https://yourapi.com/supplier/orders?status=$filter"));
  //   if (response.statusCode == 200) {
  //     final List data = jsonDecode(response.body);
  //     return data.map((json) => SupplierOrder.fromJson(json)).toList();
  //   } else {
  //     throw Exception("Failed to load supplier orders");
  //   }
  // }
}
