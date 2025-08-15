import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../widgets/payments/payment_card.dart';
import '../../../../shared/widgets/payments_filter_tabs.dart';
import '../widgets/supplier_bottom_nav.dart';
import '../../data/models/supplier_payment.dart';
import '../../data/services/supplier_payment_service.dart';

class SupplierPaymentsPage extends StatefulWidget {
  const SupplierPaymentsPage({super.key});

  @override
  State<SupplierPaymentsPage> createState() => _SupplierPaymentsPageState();
}

class _SupplierPaymentsPageState extends State<SupplierPaymentsPage> {
  String selectedFilter = 'All';
  int selectedIndex = 2;
  late Future<List<SupplierPayment>> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  void _fetchPayments() {
    _paymentsFuture = SupplierPaymentApiService().fetchPayments(filter: selectedFilter);
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
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/supplier-home');
          },
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
            child: FutureBuilder<List<SupplierPayment>>(
              future: _paymentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading payments"));
                }

                final payments = snapshot.data!;
                if (payments.isEmpty) {
                  return const Center(child: Text("No payments found"));
                }

                return ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) =>
                      PaymentCard(payment: payments[index]),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: const SupplierBottomNav(selectedIndex: 2),
    );
  }
}
