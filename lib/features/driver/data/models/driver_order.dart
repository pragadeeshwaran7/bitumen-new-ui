class DriverOrder {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String pickupLocation;
  final String pickupAddress;
  final String dropLocation;
  final String dropAddress;
  final String bitumenType;
  final String quantityLoading;
  final String quantityUnloading;
  final String distance;
  String status;

  DriverOrder({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.dropLocation,
    required this.dropAddress,
    required this.bitumenType,
    required this.quantityLoading,
    required this.quantityUnloading,
    required this.distance,
    required this.status,
  });

  factory DriverOrder.fromJson(Map<String, dynamic> json) {
    return DriverOrder(
      orderId: json['orderId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      pickupLocation: json['pickupLocation'],
      pickupAddress: json['pickupAddress'],
      dropLocation: json['dropLocation'],
      dropAddress: json['dropAddress'],
      bitumenType: json['bitumenType'],
      quantityLoading: json['quantityLoading'],
      quantityUnloading: json['quantityUnloading'],
      distance: json['distance'],
      status: json['status'],
    );
  }
}
