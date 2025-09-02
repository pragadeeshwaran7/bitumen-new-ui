import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/orders_filter_tabs.dart';
import '../widgets/orders/order_card.dart';
import '../widgets/customer_bottom_nav.dart';
import '../../../../shared/models/order_model.dart'; // Updated import
import '../../data/services/customer_order_service.dart';

class CustomerOrdersPage extends StatefulWidget {
  const CustomerOrdersPage({super.key});

  @override
  State<CustomerOrdersPage> createState() => _CustomerOrdersPageState();
}

class _CustomerOrdersPageState extends State<CustomerOrdersPage> {
  String selectedFilter = 'All';
  int selectedIndex = 1;
  late Future<List<OrderModel>> _ordersFuture; // Changed type

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() {
    _ordersFuture = CustomerApiService().fetchOrders(filter: selectedFilter);
  }

  void _onFilterChanged(String newFilter) {
    setState(() {
      selectedFilter = newFilter;
      _fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.4,
        title: const Text("My Orders", style: TextStyle(color: AppColors.black)),
        iconTheme: const IconThemeData(color: AppColors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/customer-home');
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          OrdersFilterTabs(
            selectedFilter: selectedFilter,
            onFilterSelected: _onFilterChanged,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<OrderModel>>( // Changed type
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading orders."));
                }

                final orders = snapshot.data!;
                if (orders.isEmpty) {
                  return const Center(child: Text("No orders found."));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) => OrderCard(order: orders[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomerBottomNav(selectedIndex: 1),
    );
  }
}