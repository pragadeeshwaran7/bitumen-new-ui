import 'package:flutter/material.dart';
import '../../../../shared/widgets/common_login_form.dart';

class DriverLoginPage extends StatelessWidget {
  const DriverLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Login')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: CommonLoginForm(role: 'driver'),
      ),
    );
  }
}
