class CustomerOrder {
  final String orderId;
  final String date;
  final String pickup;
  final String delivery;
  final String goods;
  final String amount;
  final String status;
  final String? driverName;
  final String? driverPhone;
  final String? billurl;

  CustomerOrder({
    required this.orderId,
    required this.date,
    required this.pickup,
    required this.delivery,
    required this.goods,
    required this.amount,
    required this.status,
    this.driverName,
    this.driverPhone,
    this.billurl,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    return CustomerOrder(
      orderId: json['orderId'],
      date: json['date'],
      pickup: json['pickup'],
      delivery: json['delivery'],
      goods: json['goods'],
      amount: json['amount'],
      status: json['status'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      billurl: json['billurl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'date': date,
      'pickup': pickup,
      'delivery': delivery,
      'goods': goods,
      'amount': amount,
      'status': status,
    };
  }
}
