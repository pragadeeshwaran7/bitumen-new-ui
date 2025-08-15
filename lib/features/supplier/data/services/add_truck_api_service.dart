import '../models/add_truck_model.dart';

class AddTruckApiService {
  static final AddTruckApiService _instance = AddTruckApiService._internal();
  factory AddTruckApiService() => _instance;
  AddTruckApiService._internal();

  final List<Map<String, dynamic>> _mockTankers = [];

  Future<void> addTruck(AddTruckModel truck) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockTankers.add(truck.toJson());
  }

  List<Map<String, dynamic>> getAllMockTankers() {
    return _mockTankers;
  }

  // TODO: When backend is ready, replace `addTruck` with actual POST request
  // Future<void> addTruckToBackend(AddTruckModel truck) async {
  //   final response = await http.post(
  //     Uri.parse('https://api.example.com/trucks'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(truck.toJson()),
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to add truck');
  //   }
  // }
}
