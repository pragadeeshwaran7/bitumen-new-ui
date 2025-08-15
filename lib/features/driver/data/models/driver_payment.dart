class DriverPayment {
  final String driverId;
  final String kmcovered;
  final String incentive;

  DriverPayment({
    required this.driverId, 
    required this.kmcovered, 
    required this.incentive,
    });

  factory DriverPayment.fromJson(Map<String, dynamic> json) {
    return DriverPayment(
      driverId: json['driverId'],
      kmcovered: json['kmcovered'],
      incentive: json['incentive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'kmcovered': kmcovered,
      'incentive': incentive,
    };
  }
}