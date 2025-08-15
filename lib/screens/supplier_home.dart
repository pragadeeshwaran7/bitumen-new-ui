import 'package:flutter/material.dart';

class SupplierHomePage extends StatefulWidget {
  const SupplierHomePage({super.key});

  @override
  State<SupplierHomePage> createState() => _SupplierHomePageState();
}

class _SupplierHomePageState extends State<SupplierHomePage> {
  int selectedIndex = 0;
  String supplierName = "ABC Suppliers"; // Replace dynamically after login
  String selectedTab = "Available Tankers";

  List<Map<String, dynamic>> tankerList = [
    {
      'tankerNo': 'MH12AB1234',
      'type': 'Large Tanker',
      'maxQty': '35 Tons',
      'allowedQty': '30 Tons',
      'rcNo': 'RC123456789',
      'rcExpiry': '2026-10-15',
      'insuranceNo': 'INS987654321',
      'insuranceExpiry': '2025-12-01',
      'status': 'Available',
      'driverAssigned': false,
      'driverName': '',
      'driverPhone': '',
    },
    {
      'tankerNo': 'MH14CD5678',
      'type': 'Medium Tanker',
      'maxQty': '25 Tons',
      'allowedQty': '22 Tons',
      'rcNo': 'RC789012345',
      'rcExpiry': '2025-08-20',
      'insuranceNo': 'INS123456789',
      'insuranceExpiry': '2025-09-30',
      'status': 'In Transit',
      'driverAssigned': true,
      'driverName': 'Ravi Kumar',
      'driverPhone': '9876543210',
    },
    {
      'tankerNo': 'MH13EF6789',
      'type': 'Small Tanker',
      'maxQty': '15 Tons',
      'allowedQty': '12 Tons',
      'rcNo': 'RC543216789',
      'rcExpiry': '2026-03-25',
      'insuranceNo': 'INS654321987',
      'insuranceExpiry': '2025-07-15',
      'status': 'In Service',
      'driverAssigned': false,
      'driverName': '',
      'driverPhone': '',
    },
  ];

  void onBottomBarTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
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
        Navigator.pushReplacementNamed(context, '/supplier-account');
        break;
    }
  }

  void assignDriver(int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final availableDrivers = [
          {'name': 'Ajay Sharma', 'phone': '9123456789'},
          {'name': 'Suresh Rao', 'phone': '9234567890'},
        ];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: availableDrivers.map((driver) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(driver['name']!),
              subtitle: Text(driver['phone']!),
              onTap: () {
                setState(() {
                  tankerList[index]['driverAssigned'] = true;
                  tankerList[index]['driverName'] = driver['name'];
                  tankerList[index]['driverPhone'] = driver['phone'];
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTankers =
        tankerList.where((tanker) {
      if (selectedTab == "Available Tankers") return tanker['status'] == 'Available';
      if (selectedTab == "Active Tankers") return tanker['status'] == 'In Transit';
      if (selectedTab == "Disabled Tankers") return tanker['status'] == 'In Service';
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Welcome, $supplierName",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/add-tanker'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCEEEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.fire_truck, color: Colors.red),
                          SizedBox(height: 6),
                          Text("Add Tanker", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/add-driver'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F6FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.person_add, color: Colors.blue),
                          SizedBox(height: 6),
                          Text("Add Driver", style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Available Tankers', 'Active Tankers', 'Disabled Tankers'].map((tab) {
                final isSelected = selectedTab == tab;
                return GestureDetector(
                  onTap: () => setState(() => selectedTab = tab),
                  child: Column(
                    children: [
                      Text(
                        tab.replaceAll(" Tankers", ""),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.red : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 40,
                        color: isSelected ? Colors.red : Colors.transparent,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTankers.length,
              itemBuilder: (context, index) {
                final tanker = filteredTankers[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tanker['tankerNo'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: tanker['status'] == 'Available'
                                  ? Colors.green.shade100
                                  : tanker['status'] == 'In Transit'
                                      ? Colors.orange.shade100
                                      : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              tanker['status'],
                              style: TextStyle(
                                color: tanker['status'] == 'Available'
                                    ? Colors.green
                                    : tanker['status'] == 'In Transit'
                                        ? Colors.orange
                                        : Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      buildRow("Tanker Type", tanker['type']),
                      buildRow("Max Qty", tanker['maxQty']),
                      buildRow("Allowed Qty", tanker['allowedQty']),
                      const Divider(),
                      buildRow("RC No", tanker['rcNo']),
                      buildRow("RC Expiry", tanker['rcExpiry']),
                      buildRow("Insurance No", tanker['insuranceNo']),
                      buildRow("Insurance Expiry", tanker['insuranceExpiry']),
                      const Divider(),
                      if (selectedTab == "Available Tankers") ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {}, // Disable logic
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Disable"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: tanker['driverAssigned'] ? null : () => assignDriver(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tanker['driverAssigned'] ? Colors.grey : Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Assign Driver"),
                            ),
                          ],
                        ),
                      ] else if (selectedTab == "Disabled Tankers") ...[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => tanker['status'] = 'Available');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Enable"),
                          ),
                        ),
                      ],
                      if (selectedTab == "Active Tankers") ...[
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tanker['driverName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(tanker['driverPhone']),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.red),
                              onPressed: () {
                                // TODO: Call driver logic
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onBottomBarTap,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(color: Colors.black54))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
