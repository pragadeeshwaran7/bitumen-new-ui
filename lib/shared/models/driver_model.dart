class DriverModel {
  final String? id;
  final String? user;
  final String? role;
  final String fullName;
  final String businessAddress;
  final String licenseNumber;
  final String licenseExpiry;
  final String vehicleType;
  final double experience;
  final Map<String, String> documents;
  final Map<String, String> bankDetails;
  final bool? isAvailable;
  final double? rating;
  final int? totalTrips;
  final String? assignedTanker;
  final String? supplier;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String phoneNumber; // Added phoneNumber

  DriverModel({
    this.id,
    this.user,
    this.role,
    required this.fullName,
    required this.businessAddress,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.vehicleType,
    required this.experience,
    required this.documents,
    required this.bankDetails,
    this.isAvailable,
    this.rating,
    this.totalTrips,
    this.assignedTanker,
    this.supplier,
    this.createdAt,
    this.updatedAt,
    required this.phoneNumber, // Added phoneNumber
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['_id'],
      user: json['user'],
      role: json['role'],
      fullName: json['fullName'],
      businessAddress: json['businessAddress'],
      licenseNumber: json['licenseNumber'],
      licenseExpiry: json['licenseExpiry'],
      vehicleType: json['vehicleType'],
      experience: (json['experience'] as num).toDouble(),
      documents: Map<String, String>.from(json['documents']),
      bankDetails: Map<String, String>.from(json['bankDetails']),
      isAvailable: json['isAvailable'],
      rating: (json['rating'] as num?)?.toDouble(),
      totalTrips: json['totalTrips'],
      assignedTanker: json['assignedTanker'],
      supplier: json['supplier'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      phoneNumber: json['phoneNumber'], // Added phoneNumber
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'businessAddress': businessAddress,
      'licenseNumber': licenseNumber,
      'licenseExpiry': licenseExpiry,
      'vehicleType': vehicleType,
      'experience': experience,
      'documents': documents,
      'bankDetails': bankDetails,
      'phoneNumber': phoneNumber, // Added phoneNumber
    };
  }
}
