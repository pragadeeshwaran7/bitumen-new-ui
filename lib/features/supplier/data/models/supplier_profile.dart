class SupplierProfile {
  final String name;
  final String company;
  final String phone;
  final String email;
  final String address;

  SupplierProfile({
    required this.name,
    required this.company,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory SupplierProfile.fromJson(Map<String, dynamic> json) {
    return SupplierProfile(
      name: json['name'],
      company: json['company'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }
}
