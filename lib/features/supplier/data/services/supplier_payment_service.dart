import 'dart:async';
import '../models/supplier_payment.dart';

class SupplierPaymentApiService {
  static final SupplierPaymentApiService _instance = SupplierPaymentApiService._internal();
  factory SupplierPaymentApiService() => _instance;
  SupplierPaymentApiService._internal();

  final List<SupplierPayment> _mockPayments = [
    SupplierPayment(
      paymentMode: "Net Banking",
      amount: "₹18,750",
      date: "2025-02-18",
      orderId: "TR987654321",
      receiptId: "PAY2345678",
      status: "Pending",
    ),
    SupplierPayment(
      paymentMode: "UPI",
      amount: "₹12,000",
      date: "2025-01-10",
      orderId: "TR1122334455",
      receiptId: "PAY000011",
      status: "Completed",
    ),
  ];

  Future<List<SupplierPayment>> fetchPayments({String filter = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (filter == 'All') return _mockPayments;
    return _mockPayments.where((p) => p.status == filter).toList();
  }

  // TODO: Replace with real API logic later
  // Future<List<SupplierPayment>> fetchPaymentsFromBackend(String filter) async {
  //   final response = await http.get(Uri.parse('https://yourapi.com/supplier/payments?status=$filter'));
  //   if (response.statusCode == 200) {
  //     final List data = jsonDecode(response.body);
  //     return data.map((json) => SupplierPayment.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to fetch supplier payments');
  //   }
  // }
}
