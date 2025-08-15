import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import '../../data/models/customer_order.dart';

class CustomerApiService {
  static final CustomerApiService _instance = CustomerApiService._internal();
  factory CustomerApiService() => _instance;
  CustomerApiService._internal();

  // Mock data
  final List<CustomerOrder> _mockOrders = [
    CustomerOrder(
      orderId: "TR123456789",
      date: "2025-02-15",
      pickup: "Mumbai, Maharashtra",
      delivery: "Pune, Maharashtra",
      goods: "VG30 Bitumen (2 Tons)",
      amount: "₹12,500",
      status: "In Transit",
      driverName: "Ravi Kumar",
      driverPhone: "+91 9876543210",
      billurl: null,
    ),
    CustomerOrder(
      orderId: "TR987654321",
      date: "2025-02-18",
      pickup: "Delhi, Delhi",
      delivery: "Jaipur, Rajasthan",
      goods: "PMB Bitumen (3 Tons)",
      amount: "₹18,750",
      status: "Completed",
      driverName: "Ajay Sharma",
      driverPhone: "+91 9123456789",
      billurl: "https://example.com/bill_TR123456789.pdf",
    ),
  ];

  Future<List<CustomerOrder>> fetchOrders({String filter = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate delay

    if (filter == 'All') return _mockOrders;

    return _mockOrders.where((order) => order.status == filter).toList();
  }

  // TODO: Replace mock logic with real API
  // Future<List<CustomerOrder>> fetchOrdersFromBackend(String filter) async {
  //   final response = await http.get(Uri.parse('https://yourapi.com/orders?status=$filter'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => CustomerOrder.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load orders');
  //   }
  // }
}
