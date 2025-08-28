class UserModel {
  final String id;
  final String phoneNumber;
  final String emailAddress;
  final String? password;
  final String role; // customer, driver, supplier
  final String status; // active, inactive
  final String? profile;
  
  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.emailAddress,
    this.password,
    required this.role,
    required this.status,
    this.profile,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      password: json['password'],
      role: json['role'] ?? 'customer',
      status: json['status'] ?? 'active',
      profile: json['profile'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      if (password != null) 'password': password,
      'role': role,
      'status': status,
      if (profile != null) 'profile': profile,
    };
  }
  
  @override
  String toString() {
    return 'UserModel(id: $id, phone: $phoneNumber, email: $emailAddress, role: $role, status: $status)';
  }
}
