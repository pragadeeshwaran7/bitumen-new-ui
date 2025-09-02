import 'package:bitumen_hub/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierAccountPage extends StatelessWidget {
  const SupplierAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;

        // Placeholder user data – replace this with API response later
        final String company = "ABC Suppliers"; // TODO: Fetch from profile service
        final String address = "Chennai, Tamil Nadu"; // TODO: Fetch from profile service

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            title: const Text("My Account", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0.5,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.red,
                child: Icon(Icons.person, size: 35, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(user?.name ?? 'Guest',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(company, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // Personal Info
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Personal Information",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(children: [
                  buildInfoTile(Icons.phone, user?.phone ?? 'N/A'),
                  const Divider(),
                  buildInfoTile(Icons.email, user?.email ?? 'N/A'),
                  const Divider(),
                  buildInfoTile(Icons.location_on, address),
                ]),
              ),
              const SizedBox(height: 20),

              // Settings
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Settings",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              buildSettingTile(Icons.settings, "App Settings"),
              buildSettingTile(Icons.lock, "Privacy & Security"),
              buildSettingTile(Icons.help_outline, "Help & Support"),
            ]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 4,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/supplier-home');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, '/supplier-orders');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, '/supplier-payments');
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, '/supplier-track');
                  break;
                case 4:
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"),
              BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payments"),
              BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: "Track Order"),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
            ],
          ),
        );
      },
    );
  }

  Widget buildInfoTile(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.red),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 15)),
        )
      ],
    );
  }

  Widget buildSettingTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}