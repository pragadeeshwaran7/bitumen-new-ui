import 'dart:developer';
//import 'package:uuid/uuid.dart';
import '../models/customer_booking.dart';

class CustomerApiService {
  static final CustomerApiService _instance = CustomerApiService._internal();
  factory CustomerApiService() => _instance;
  CustomerApiService._internal();

  final List<CustomerBooking> _mockOrders = [];

  Future<void> placeOrder(CustomerBooking order) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate latency
    _mockOrders.add(order);
    log("📦 Order Placed (mock): ${order.toJson()}");
  }

  List<CustomerBooking> getOrders() => _mockOrders;

  // Replace with real API logic later
}
