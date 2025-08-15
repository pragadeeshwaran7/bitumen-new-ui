import 'package:flutter/material.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  String selectedTab = 'New Orders';

  // Placeholder list (replace with data from MongoDB API)
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': 'ORD2001',
      'date': '20 Nov 2023',
      'pickup': 'Vashi, Navi Mumbai',
      'drop': 'Panvel, Raigad',
      'bitumen': 'VG40',
      'quantity': '20 Tons',
      'distance': '32 km',
      'status': 'Pending',
    },
    {
      'orderId': 'ORD2002',
      'date': '20 Nov 2023',
      'pickup': 'Airoli, Navi Mumbai',
      'drop': 'Kalamboli, Raigad',
      'bitumen': 'VG30',
      'quantity': '25 Tons',
      'distance': '28 km',
      'status': 'Pending',
    },
  ];

  List<Map<String, dynamic>> getFilteredOrders() {
    if (selectedTab == 'New Orders') {
      return orders.where((o) => o['status'] == 'Pending').toList();
    } else if (selectedTab == 'Active') {
      return orders.where((o) => o['status'] == 'In Transit').toList();
    } else if (selectedTab == 'Completed') {
      return orders.where((o) => o['status'] == 'Completed').toList();
    }
    return [];
  }

  void onTabChange(String tab) {
    setState(() => selectedTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = getFilteredOrders();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Hello, Rajesh Kumar",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔽 Added Incentives and Distance Covered Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFFCE8E8),
                          child: Icon(Icons.wallet_giftcard, color: Colors.red),
                          radius: 18,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "₹0", // Placeholder
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Incentives",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFE8F5FE),
                          child: Icon(Icons.location_on, color: Colors.blue),
                          radius: 18,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "0 km", // Placeholder
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Distance Covered",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  ['New Orders', 'Active', 'Completed'].map((tab) {
                    final isSelected = selectedTab == tab;
                    return GestureDetector(
                      onTap: () => onTabChange(tab),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isSelected ? Colors.red : Colors.grey[200],
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          // Order Cards
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #${order['orderId']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              "Pending",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order['date'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.circle, size: 10, color: Colors.red),
                          const SizedBox(width: 6),
                          Expanded(child: Text(order['pickup'])),
                          const Icon(Icons.arrow_forward),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 6),
                          Expanded(child: Text(order['drop'])),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildLabelValue("Bitumen", order['bitumen']),
                          buildLabelValue("Quantity", order['quantity']),
                          buildLabelValue("Distance", order['distance']),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/driver-order');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(130, 40),
                          ),
                          child: const Text("Accept Order"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
