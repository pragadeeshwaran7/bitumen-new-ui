class CustomerPayment {
  final String paymentMode;
  final String amount;
  final String date;
  final String orderId;
  final String receiptId;
  final String status;

  CustomerPayment({
    required this.paymentMode,
    required this.amount,
    required this.date,
    required this.orderId,
    required this.receiptId,
    required this.status,
  });

  factory CustomerPayment.fromJson(Map<String, dynamic> json) {
    return CustomerPayment(
      paymentMode: json['payment_mode'],
      amount: json['amount'],
      date: json['date'],
      orderId: json['order_id'],
      receiptId: json['receipt_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_mode': paymentMode,
      'amount': amount,
      'date': date,
      'order_id': orderId,
      'receipt_id': receiptId,
      'status': status,
    };
  }
}
