import 'package:flutter/material.dart';
import '../../../../../core/services/driver_service.dart';
import '../../../../../shared/models/driver_model.dart';

class AssignDriverModal extends StatefulWidget {
  final void Function(DriverModel) onSelect;

  const AssignDriverModal({super.key, required this.onSelect});

  @override
  State<AssignDriverModal> createState() => _AssignDriverModalState();
}

class _AssignDriverModalState extends State<AssignDriverModal> {
  late Future<List<DriverModel>> _driversFuture;

  @override
  void initState() {
    super.initState();
    _driversFuture = _loadDrivers();
  }

  Future<List<DriverModel>> _loadDrivers() async {
    final resp = await DriverService().getDrivers();
    return resp.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DriverModel>>(
      future: _driversFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('No available drivers found.')),
          );
        }

        final availableDrivers = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: availableDrivers.map((driver) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(driver.fullName), // Changed to fullName
              subtitle: Text(driver.phoneNumber), // Changed to phoneNumber
              onTap: () {
                widget.onSelect(driver);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}