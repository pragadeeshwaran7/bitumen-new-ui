import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/orders_filter_tabs.dart';
import '../widgets/orders/supplier_order_card.dart';
import '../widgets/supplier_bottom_nav.dart';
import '../../data/services/supplier_order_service.dart';
import '../../data/models/supplier_order.dart';


class SupplierOrdersPage extends StatefulWidget {
  const SupplierOrdersPage({super.key});

  @override
  State<SupplierOrdersPage> createState() => _SupplierOrdersPageState();
}

class _SupplierOrdersPageState extends State<SupplierOrdersPage> {
  String selectedFilter = 'All';
  int selectedIndex = 1;
  late Future<List<SupplierOrder>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() {
    _ordersFuture = SupplierOrderApiService().fetchOrders(filter: selectedFilter);
  }

  void _onFilterChanged(String filter) {
    setState(() {
      selectedFilter = filter;
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
          onPressed: () => Navigator.pushReplacementNamed(context, '/supplier-home'),
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
            child: FutureBuilder<List<SupplierOrder>>(
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
                  itemBuilder: (context, index) =>
                      SupplierOrderCard(order: orders[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SupplierBottomNav(selectedIndex: 1),
    );
  }
}
