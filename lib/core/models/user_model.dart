enum UserType {
  customer,
  driver,
  supplier,
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: UserType.values.firstWhere((e) => e.toString() == 'UserType.${json['userType']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType.toString().split('.').last,
    };
  }
}