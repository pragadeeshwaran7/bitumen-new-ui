class CustomerBooking {
  final String id;
  final String tankerType;
  final String goods;
  final int loadingQty;
  final int unloadingQty;
  final String pickup;
  final String drop;
  final String receiverName;
  final String receiverPhone;
  final String receiverEmail;
  final int distance;
  final int ratePerKm;
  final String paymentMethod;
  final int totalAmount;
  final int advanceAmount;
  final int balanceAmount;
  final String status;
  final DateTime date;

  CustomerBooking({
    required this.id,
    required this.tankerType,
    required this.goods,
    required this.loadingQty,
    required this.unloadingQty,
    required this.pickup,
    required this.drop,
    required this.receiverName,
    required this.receiverPhone,
    required this.receiverEmail,
    required this.distance,
    required this.ratePerKm,
    required this.paymentMethod,
    required this.totalAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.status,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "tankerType": tankerType,
        "goods": goods,
        "loadingQty": loadingQty,
        "unloadingQty": unloadingQty,
        "pickup": pickup,
        "drop": drop,
        "receiverName": receiverName,
        "receiverPhone": receiverPhone,
        "receiverEmail": receiverEmail,
        "distance": distance,
        "ratePerKm": ratePerKm,
        "paymentMethod": paymentMethod,
        "totalAmount": totalAmount,
        "advanceAmount": advanceAmount,
        "balanceAmount": balanceAmount,
        "status": status,
        "date": date.toIso8601String(),
      };
}
