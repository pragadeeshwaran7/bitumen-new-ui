class Driver {
  final String name;
  final String phone;
  final String email;
  final String licenseNumber;
  final String aadharNumber;
  final String? licenseFilePath;
  final String? aadharFilePath;

  Driver({
    required this.name,
    required this.phone,
    required this.email,
    required this.licenseNumber,
    required this.aadharNumber,
    this.licenseFilePath,
    this.aadharFilePath,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "email": email,
        "licenseNumber": licenseNumber,
        "aadharNumber": aadharNumber,
        "licenseFilePath": licenseFilePath ?? "",
        "aadharFilePath": aadharFilePath ?? "",
      };
}
