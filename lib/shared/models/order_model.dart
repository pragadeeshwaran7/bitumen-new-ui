class OrderModel {
  final String? id;
  final String pickupLocation;
  final String dropLocation;
  final DateTime pickupDate;
  final DateTime dropDate;
  final String receiverName;
  final String receiverPhone;
  final String? receiverEmail;
  final String goodsType;
  final String? goodsClass;
  final double quantityAtLoading;
  final double quantityAtUnloading;
  // Additional fields from response
  final String? status;
  final String? tankerType;
  final double? distance;
  final double? ratePerKm;
  final String? paymentMethod;
  final double? totalAmount;
  final double? advanceAmount;
  final double? balanceAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.id,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupDate,
    required this.dropDate,
    required this.receiverName,
    required this.receiverPhone,
    this.receiverEmail,
    required this.goodsType,
    this.goodsClass,
    required this.quantityAtLoading,
    required this.quantityAtUnloading,
    this.status,
    this.tankerType,
    this.distance,
    this.ratePerKm,
    this.paymentMethod,
    this.totalAmount,
    this.advanceAmount,
    this.balanceAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      pickupLocation: json['pickupLocation'],
      dropLocation: json['dropLocation'],
      pickupDate: DateTime.parse(json['pickupDate']),
      dropDate: DateTime.parse(json['dropDate']),
      receiverName: json['receiverName'],
      receiverPhone: json['receiverPhone'],
      receiverEmail: json['receiverEmail'],
      goodsType: json['goodsType'],
      goodsClass: json['goodsClass'],
      quantityAtLoading: (json['quantityAtLoading'] as num).toDouble(),
      quantityAtUnloading: (json['quantityAtUnloading'] as num).toDouble(),
      status: json['status'],
      tankerType: json['tankerType'],
      distance: (json['distance'] as num?)?.toDouble(),
      ratePerKm: (json['ratePerKm'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'],
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      advanceAmount: (json['advanceAmount'] as num?)?.toDouble(),
      balanceAmount: (json['balanceAmount'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupDate': pickupDate.toIso8601String(),
      'dropDate': dropDate.toIso8601String(),
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'receiverEmail': receiverEmail,
      'goodsType': goodsType,
      'quantityAtLoading': quantityAtLoading,
      'quantityAtUnloading': quantityAtUnloading,
      'tankerType': tankerType,
      'distance': distance,
      'ratePerKm': ratePerKm,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'advanceAmount': advanceAmount,
      'balanceAmount': balanceAmount,
      'status': status,
    };
  }
}
