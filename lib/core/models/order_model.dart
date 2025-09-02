enum OrderStatus {
  pending,
  assigned,
  inTransit,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String customerId;
  final String? supplierId;
  final String? driverId;
  final String pickupLocation;
  final String dropoffLocation;
  final double quantity;
  final String product;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.customerId,
    this.supplierId,
    this.driverId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.quantity,
    required this.product,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customerId'],
      supplierId: json['supplierId'],
      driverId: json['driverId'],
      pickupLocation: json['pickupLocation'],
      dropoffLocation: json['dropoffLocation'],
      quantity: json['quantity'].toDouble(),
      product: json['product'],
      status: OrderStatus.values.firstWhere((e) => e.toString() == 'OrderStatus.${json['status']}'),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'supplierId': supplierId,
      'driverId': driverId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'quantity': quantity,
      'product': product,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}