
class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String? companyName;
  final String? address;
  final String? gstNumber;
  final String? panNumber;
  final Map<String, dynamic>? location;
  final List<String>? documents;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.companyName,
    this.address,
    this.gstNumber,
    this.panNumber,
    this.location,
    this.documents,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      companyName: json['companyName'],
      address: json['address'],
      gstNumber: json['gstNumber'],
      panNumber: json['panNumber'],
      location: json['location'] is Map ? Map<String, dynamic>.from(json['location']) : null,
      documents: json['documents'] is List ? List<String>.from(json['documents']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      if (companyName != null) 'companyName': companyName,
      if (address != null) 'address': address,
      if (gstNumber != null) 'gstNumber': gstNumber,
      if (panNumber != null) 'panNumber': panNumber,
      if (location != null) 'location': location,
      if (documents != null) 'documents': documents,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? companyName,
    String? address,
    String? gstNumber,
    String? panNumber,
    Map<String, dynamic>? location,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role,
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      location: location ?? this.location,
      documents: documents,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, role: $role, companyName: $companyName)';
  }
}
