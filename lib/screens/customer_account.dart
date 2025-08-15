import 'package:flutter/material.dart';

class CustomerAccountPage extends StatelessWidget {
  const CustomerAccountPage({super.key});

  // Placeholder user data – replace this with API response later
  final String userName = "John Doe";
  final String company = "ABC Logistics";
  final String phone = "9390540800";
  final String email = "john.doe@example.com";
  final String address = "Mumbai, Maharashtra";

  @override
  Widget build(BuildContext context) {
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
          Text(userName,
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
              buildInfoTile(Icons.phone, phone),
              const Divider(),
              buildInfoTile(Icons.email, email),
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
              Navigator.pushReplacementNamed(context, '/customer-home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/customer-orders');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/customer-payments');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/customer-track');
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
