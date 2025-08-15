import 'package:flutter/material.dart';
import '../../../data/services/tanker_api_service.dart';

class AssignDriverModal extends StatefulWidget {
  final void Function(Map<String, String>) onSelect;

  const AssignDriverModal({super.key, required this.onSelect});

  @override
  State<AssignDriverModal> createState() => _AssignDriverModalState();
}

class _AssignDriverModalState extends State<AssignDriverModal> {
  late Future<List<Map<String, String>>> _driversFuture;

  @override
  void initState() {
    super.initState();
    _driversFuture = TankerApiService().fetchAvailableDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
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
              title: Text(driver['name']!),
              subtitle: Text(driver['phone']!),
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
