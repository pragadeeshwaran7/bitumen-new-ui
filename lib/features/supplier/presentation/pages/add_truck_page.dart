import 'package:flutter/material.dart';
import '../widgets/add_truck/add_truck_form.dart';

class AddTruckPage extends StatelessWidget {
  const AddTruckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Add Tanker"),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/supplier-home');
          },
        ), 
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: AddTruckForm(),
      ),
    );
  }
}
