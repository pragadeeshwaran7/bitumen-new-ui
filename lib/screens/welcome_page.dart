import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red,
              child: Icon(Icons.local_shipping, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('Bitumen Hub',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Logistics & Transportation',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('Welcome',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text('Choose how you want to continue',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/customer_login'),
                        icon: const Icon(Icons.person_outline),
                        label: const Text("Continue as Customer"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/driver_login'),
                        icon: const Icon(Icons.local_shipping_outlined),
                        label: const Text("Continue as Tanker Driver"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/supplier_login'),
                        icon: const Icon(Icons.fire_truck),
                        label: const Text("Continue as Tanker Supplier"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'By continuing, you agree to our Terms of Service and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
