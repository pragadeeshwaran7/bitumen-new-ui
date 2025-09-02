enum TankerStatus {
  available,
  inUse,
  maintenance,
}

class Tanker {
  final String id;
  final String supplierId;
  final String? driverId;
  final String licensePlate;
  final double capacity;
  final TankerStatus status;

  Tanker({
    required this.id,
    required this.supplierId,
    this.driverId,
    required this.licensePlate,
    required this.capacity,
    required this.status,
  });

  factory Tanker.fromJson(Map<String, dynamic> json) {
    return Tanker(
      id: json['id'],
      supplierId: json['supplierId'],
      driverId: json['driverId'],
      licensePlate: json['licensePlate'],
      capacity: json['capacity'].toDouble(),
      status: TankerStatus.values.firstWhere((e) => e.toString() == 'TankerStatus.${json['status']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierId': supplierId,
      'driverId': driverId,
      'licensePlate': licensePlate,
      'capacity': capacity,
      'status': status.toString().split('.').last,
    };
  }
}
