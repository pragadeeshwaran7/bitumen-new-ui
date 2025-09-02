import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../widgets/payments/payment_card.dart';
import '../../../../shared/widgets/payments_filter_tabs.dart';
import '../widgets/customer_bottom_nav.dart';
import '../../data/services/customer_payment_service.dart';
import '../../../../shared/models/order_model.dart'; // Updated import

class CustomerPaymentsPage extends StatefulWidget {
  const CustomerPaymentsPage({super.key});

  @override
  State<CustomerPaymentsPage> createState() => _CustomerPaymentsPageState();
}

class _CustomerPaymentsPageState extends State<CustomerPaymentsPage> {
  String selectedFilter = 'All';
  int selectedIndex = 2;
  late Future<List<OrderModel>> _paymentsFuture; // Changed type

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  void _fetchPayments() {
    _paymentsFuture = CustomerPaymentApiService().fetchPayments(filter: selectedFilter);
  }

  void _onFilterChanged(String filter) {
    setState(() {
      selectedFilter = filter;
      _fetchPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.4,
        title: const Text("Payments", style: TextStyle(color: AppColors.black)),
        iconTheme: const IconThemeData(color: AppColors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/customer-home'),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          PaymentsFilterTabs(
            selectedFilter: selectedFilter,
            onFilterSelected: _onFilterChanged,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<OrderModel>>( // Changed type
              future: _paymentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading payments."));
                }

                final payments = snapshot.data!;
                if (payments.isEmpty) {
                  return const Center(child: Text("No payments found."));
                }

                return ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) => PaymentCard(payment: payments[index]),
                );
              },
            ),
          )
        ],

      ),
      bottomNavigationBar: const CustomerBottomNav(selectedIndex: 2),
    );
  }
}