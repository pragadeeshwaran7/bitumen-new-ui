import 'package:flutter/material.dart';

class CustomerPaymentsPage extends StatefulWidget {
  const CustomerPaymentsPage({super.key});

  @override
  State<CustomerPaymentsPage> createState() => _CustomerPaymentsPageState();
}

class _CustomerPaymentsPageState extends State<CustomerPaymentsPage> {
  String selectedFilter = 'All';
  int selectedIndex = 2;

  // Placeholder payments data
  final List<Map<String, dynamic>> allPayments = [
    {
      "payment_mode": "Net Banking",
      "amount": "₹18,750",
      "date": "2025-02-18",
      "order_id": "TR987654321",
      "receipt_id": "PAY2345678",
      "status": "Pending"
    },
    // Add more entries if needed
  ];

  List<Map<String, dynamic>> get filteredPayments {
    if (selectedFilter == 'All') return allPayments;
    return allPayments.where((p) => p['status'] == selectedFilter).toList();
  }

  void onBottomBarTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/customer-home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/customer-orders');
        break;
      case 2:
        break; // Stay on Payments
      case 3:
        Navigator.pushReplacementNamed(context, '/customer-track');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/customer-account');
        break;
    }
  }

  Widget buildFilterButton(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (label == 'Completed') const Icon(Icons.check_circle_outline, size: 16),
            if (label == 'Pending') const Icon(Icons.schedule, size: 16),
            if (label == 'All') const Icon(Icons.receipt_long, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentCard(Map<String, dynamic> payment) {
    Color statusColor = payment['status'] == 'Pending'
        ? Colors.orange
        : payment['status'] == 'Completed'
            ? Colors.green
            : Colors.grey;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.credit_card, color: Colors.red, size: 18),
                const SizedBox(width: 6),
                Text(payment['payment_mode'],
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(payment['status'],
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(payment['amount'],
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 4),
        Text(payment['date'],
            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(height: 8),
        Text("Order: ${payment['order_id']}",
            style: const TextStyle(fontSize: 13)),
        Text("Receipt: ${payment['receipt_id']}",
            style: const TextStyle(fontSize: 13)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        title: const Text("Payments", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['All', 'Completed', 'Pending']
                .map(buildFilterButton)
                .toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPayments.length,
              itemBuilder: (context, index) =>
                  buildPaymentCard(filteredPayments[index]),
            ),
          )
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
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes), label: 'Track Order'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}
