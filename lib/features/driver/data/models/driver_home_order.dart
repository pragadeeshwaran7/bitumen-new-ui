class DriverHomeOrder {
  final String orderId;
  final String date;
  final String pickup;
  final String drop;
  final String bitumen;
  final String quantity;
  final String distance;
  String status; // mutable for accepting order

  DriverHomeOrder({
    required this.orderId,
    required this.date,
    required this.pickup,
    required this.drop,
    required this.bitumen,
    required this.quantity,
    required this.distance,
    required this.status,
  });

  factory DriverHomeOrder.fromJson(Map<String, dynamic> json) {
    return DriverHomeOrder(
      orderId: json['orderId'],
      date: json['date'],
      pickup: json['pickup'],
      drop: json['drop'],
      bitumen: json['bitumen'],
      quantity: json['quantity'],
      distance: json['distance'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'date': date,
      'pickup': pickup,
      'drop': drop,
      'bitumen': bitumen,
      'quantity': quantity,
      'distance': distance,
      'status': status,
    };
  }
}
