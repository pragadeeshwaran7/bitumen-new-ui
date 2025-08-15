class AddTruckModel {
  final String tankerNumber;
  final String tankerType;
  final String maxCapacity;
  final String permissibleLimit;
  final String rcNumber;
  final String rcExpiry;
  final String insuranceNumber;
  final String insuranceExpiry;
  final String fcNumber;
  final String fcExpiry;
  final String npNumber;
  final String npExpiry;

  AddTruckModel({
    required this.tankerNumber,
    required this.tankerType,
    required this.maxCapacity,
    required this.permissibleLimit,
    required this.rcNumber,
    required this.rcExpiry,
    required this.insuranceNumber,
    required this.insuranceExpiry,
    required this.fcNumber,
    required this.fcExpiry,
    required this.npNumber,
    required this.npExpiry,
  });

  Map<String, dynamic> toJson() {
    return {
      'tankerNo': tankerNumber,
      'type': tankerType,
      'maxQty': maxCapacity,
      'allowedQty': permissibleLimit,
      'rcNo': rcNumber,
      'rcExpiry': rcExpiry,
      'insuranceNo': insuranceNumber,
      'insuranceExpiry': insuranceExpiry,
      'fcNo': fcNumber,
      'fcExpiry': fcExpiry,
      'npNo': npNumber,
      'npExpiry': npExpiry,
      'status': 'Available',
      'driverAssigned': false,
    };
  }
}
