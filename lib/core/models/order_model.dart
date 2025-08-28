class OrderModel {
  final String? id;
  final String? customerId;
  final String? supplierId;
  final String? driverId;
  final String materialType;
  final double quantity;
  final String unit;
  final String pickupLocation;
  final String deliveryLocation;
  final DateTime? pickupDate;
  final DateTime? deliveryDate;
  final String status;
  final double? amount;
  final String? paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  OrderModel({
    this.id,
    this.customerId,
    this.supplierId,
    this.driverId,
    required this.materialType,
    required this.quantity,
    required this.unit,
    required this.pickupLocation,
    required this.deliveryLocation,
    this.pickupDate,
    this.deliveryDate,
    this.status = 'pending',
    this.amount,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });
  
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'],
      customerId: json['customerId'],
      supplierId: json['supplierId'],
      driverId: json['driverId'],
      materialType: json['materialType'] ?? '',
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'tons',
      pickupLocation: json['pickupLocation'] ?? '',
      deliveryLocation: json['deliveryLocation'] ?? '',
      pickupDate: json['pickupDate'] != null 
          ? DateTime.parse(json['pickupDate']) 
          : null,
      deliveryDate: json['deliveryDate'] != null 
          ? DateTime.parse(json['deliveryDate']) 
          : null,
      status: json['status'] ?? 'pending',
      amount: json['amount']?.toDouble(),
      paymentStatus: json['paymentStatus'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (customerId != null) 'customerId': customerId,
      if (supplierId != null) 'supplierId': supplierId,
      if (driverId != null) 'driverId': driverId,
      'materialType': materialType,
      'quantity': quantity,
      'unit': unit,
      'pickupLocation': pickupLocation,
      'deliveryLocation': deliveryLocation,
      if (pickupDate != null) 'pickupDate': pickupDate!.toIso8601String(),
      if (deliveryDate != null) 'deliveryDate': deliveryDate!.toIso8601String(),
      'status': status,
      if (amount != null) 'amount': amount,
      if (paymentStatus != null) 'paymentStatus': paymentStatus,
    };
  }
  
  @override
  String toString() {
    return 'OrderModel(id: $id, material: $materialType, quantity: $quantity, status: $status)';
  }
}
