class Tanker {
  String tankerNo;
  String type;
  String maxQty;
  String allowedQty;
  String rcNo;
  String rcExpiry;
  String insuranceNo;
  String insuranceExpiry;
  String status;
  bool driverAssigned;
  String? driverName;
  String? driverPhone;

  Tanker({
    required this.tankerNo,
    required this.type,
    required this.maxQty,
    required this.allowedQty,
    required this.rcNo,
    required this.rcExpiry,
    required this.insuranceNo,
    required this.insuranceExpiry,
    required this.status,
    required this.driverAssigned,
    this.driverName,
    this.driverPhone,
  });

  factory Tanker.fromJson(Map<String, dynamic> json) => Tanker(
        tankerNo: json['tankerNo'],
        type: json['type'],
        maxQty: json['maxQty'],
        allowedQty: json['allowedQty'],
        rcNo: json['rcNo'],
        rcExpiry: json['rcExpiry'],
        insuranceNo: json['insuranceNo'],
        insuranceExpiry: json['insuranceExpiry'],
        status: json['status'],
        driverAssigned: json['driverAssigned'],
        driverName: json['driverName'],
        driverPhone: json['driverPhone'],
      );

  Map<String, dynamic> toJson() => {
        'tankerNo': tankerNo,
        'type': type,
        'maxQty': maxQty,
        'allowedQty': allowedQty,
        'rcNo': rcNo,
        'rcExpiry': rcExpiry,
        'insuranceNo': insuranceNo,
        'insuranceExpiry': insuranceExpiry,
        'status': status,
        'driverAssigned': driverAssigned,
        'driverName': driverName,
        'driverPhone': driverPhone,
      };
}
