class DriverModel {
  final String driverId;
  final String name;
  final String phone;

  DriverModel({
    required this.driverId,
    required this.name, 
    required this.phone, 
    });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      driverId: json['driverId'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}