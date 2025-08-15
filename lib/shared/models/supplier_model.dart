class SupplierModel {
  final String supplierId;
  final String name;

  SupplierModel({
    required this.supplierId, 
    required this.name,
    });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      supplierId: json['supplierId'],
      name: json['name'],
    );
  }
}