class CustomerProfile {
  final String name;
  final String company;
  final String phone;
  final String email;
  final String address;

  CustomerProfile({
    required this.name,
    required this.company,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      name: json['name'],
      company: json['company'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }
}
