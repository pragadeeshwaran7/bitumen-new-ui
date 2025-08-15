import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupplierOrdersPage extends StatefulWidget {
  const SupplierOrdersPage({super.key});

  @override
  State<SupplierOrdersPage> createState() => _SupplierOrdersPageState();
}

class _SupplierOrdersPageState extends State<SupplierOrdersPage> {
  String selectedFilter = 'All';
  int selectedIndex = 1;

  // Placeholder data
  final List<Map<String, dynamic>> allOrders = [
    {
      "orderId": "TR123456789",
      "date": "2025-02-15",
      "pickup": "Mumbai, Maharashtra",
      "delivery": "Pune, Maharashtra",
      "truckNo": "MH12AB1234",
      "amount": "₹12,500",
      "status": "In Transit",
    },
    {
      "orderId": "TR987654321",
      "date": "2025-02-18",
      "pickup": "Delhi, Delhi",
      "delivery": "Jaipur, Rajasthan",
      "truckNo": "MH12AB1234",
      "amount": "₹18,750",
      "status": "Pending",
    },
  ];

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedFilter == 'All') return allOrders;
    return allOrders.where((o) => o['status'] == selectedFilter).toList();
  }

  void onBottomBarTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/supplier-home');
        break;
      case 1:
        // stay on Orders
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

  Widget buildTabButton(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildOrderCard(Map<String, dynamic> order) {
    Color statusColor;
    if (order['status'] == 'In Transit') {
      statusColor = Colors.red;
    } else if (order['status'] == 'Pending') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    // Placeholder driver data — in actual implementation, attach this to the order object
    final String driverName = "Ravi Kumar";
    final String driverPhone = "+91 9876543210";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['orderId'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Date", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(
            order['date'],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                children: [
                  Icon(Icons.circle, color: Colors.red, size: 10),
                  SizedBox(height: 30),
                  Icon(Icons.circle_outlined, color: Colors.red, size: 10),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pickup",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(order['pickup']),
                  const SizedBox(height: 20),
                  const Text(
                    "Delivery",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(order['delivery']),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['truckNo'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                order['amount'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Driver info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Driver: $driverName",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Phone: $driverPhone",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              // Call button
              ElevatedButton.icon(
                onPressed: () async {
                  final Uri phoneUri = Uri(scheme: 'tel', path: driverPhone);
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    throw 'Could not launch $phoneUri';
                  }
                },
                icon: const Icon(Icons.call),
                label: const Text("Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        title: const Text("My Orders", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                [
                  'All',
                  'Current',
                  'Pending',
                  'Completed',
                ].map(buildTabButton).toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder:
                  (context, index) => buildOrderCard(filteredOrders[index]),
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
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Track Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
