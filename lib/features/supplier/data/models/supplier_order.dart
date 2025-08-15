class SupplierOrder {
  final String orderId;
  final String date;
  final String pickup;
  final String delivery;
  final String truckNo;
  final String amount;
  final String status;
  final String driverName;
  final String driverPhone;

  SupplierOrder({
    required this.orderId,
    required this.date,
    required this.pickup,
    required this.delivery,
    required this.truckNo,
    required this.amount,
    required this.status,
    required this.driverName,
    required this.driverPhone,
  });

  factory SupplierOrder.fromJson(Map<String, dynamic> json) {
    return SupplierOrder(
      orderId: json['orderId'],
      date: json['date'],
      pickup: json['pickup'],
      delivery: json['delivery'],
      truckNo: json['truckNo'],
      amount: json['amount'],
      status: json['status'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'date': date,
      'pickup': pickup,
      'delivery': delivery,
      'truckNo': truckNo,
      'amount': amount,
      'status': status,
    };
  }
}
