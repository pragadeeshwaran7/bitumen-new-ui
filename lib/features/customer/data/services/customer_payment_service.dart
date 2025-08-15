import 'dart:async';
import '../../data/models/customer_payment.dart';

class CustomerPaymentApiService {
  static final CustomerPaymentApiService _instance = CustomerPaymentApiService._internal();
  factory CustomerPaymentApiService() => _instance;
  CustomerPaymentApiService._internal();

  final List<CustomerPayment> _mockPayments = [
    CustomerPayment(
      paymentMode: "Net Banking",
      amount: "₹18,750",
      date: "2025-02-18",
      orderId: "TR987654321",
      receiptId: "PAY2345678",
      status: "Pending",
    ),
    CustomerPayment(
      paymentMode: "UPI",
      amount: "₹12,000",
      date: "2025-01-10",
      orderId: "TR555111222",
      receiptId: "PAY1110001",
      status: "Completed",
    ),
  ];

  Future<List<CustomerPayment>> fetchPayments({String filter = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (filter == 'All') return _mockPayments;
    return _mockPayments.where((p) => p.status == filter).toList();
  }

  // TODO: Replace with real API call
  // Future<List<CustomerPayment>> fetchPaymentsFromBackend(String filter) async {
  //   final response = await http.get(Uri.parse("https://yourapi.com/customer/payments?status=$filter"));
  //   if (response.statusCode == 200) {
  //     final List data = jsonDecode(response.body);
  //     return data.map((json) => CustomerPayment.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load payments');
  //   }
  // }
}
