import 'package:bitumen_hub/core/models/order_model.dart';
import 'package:bitumen_hub/core/models/tanker_model.dart';
import 'package:bitumen_hub/core/services/order_service.dart';
import 'package:bitumen_hub/core/services/tanker_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierOrdersScreen extends StatefulWidget {
  const SupplierOrdersScreen({super.key});

  @override
  State<SupplierOrdersScreen> createState() => _SupplierOrdersScreenState();
}

class _SupplierOrdersScreenState extends State<SupplierOrdersScreen> {
  List<Order> _orders = [];
  List<Tanker> _tankers = [];
  bool _isLoading = true;
  String? _selectedTankerId;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final orderService = Provider.of<OrderService>(context, listen: false);
    final tankerService = Provider.of<TankerService>(context, listen: false);

    final ordersResponse = await orderService.getSupplierOrders();
    final tankersResponse = await tankerService.getSupplierTankers();

    if (ordersResponse.success && tankersResponse.success) {
      setState(() {
        _orders = ordersResponse.data!;
        _tankers = tankersResponse.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ordersResponse.error ?? tankersResponse.error ?? 'Failed to fetch data')),
      );
    }
  }

  Future<void> _assignTanker(String orderId) async {
    if (_selectedTankerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a tanker')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final orderService = Provider.of<OrderService>(context, listen: false);
    final response = await orderService.assignTankerToOrder(
      orderId: orderId,
      tankerId: _selectedTankerId!,
    );

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanker assigned successfully!')),
      );
      _fetchData(); // Refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error ?? 'Failed to assign tanker')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Status: ${order.status.toString().split('.').last}'),
                        Text('From: ${order.pickupLocation}'),
                        Text('To: ${order.dropoffLocation}'),
                        Text('Quantity: ${order.quantity} tons'),
                        if (order.status == OrderStatus.pending)
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedTankerId,
                                  hint: const Text('Select Tanker'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedTankerId = newValue;
                                    });
                                  },
                                  items: _tankers
                                      .where((t) => t.status == TankerStatus.available)
                                      .map((Tanker tanker) {
                                    return DropdownMenuItem<String>(
                                      value: tanker.id,
                                      child: Text(tanker.licensePlate),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => _assignTanker(order.id),
                                child: const Text('Assign'),
                              ),
                            ],
                          ),
                      ],
                    ),                  ),
                );
              },
            ),
    );
  }
}
