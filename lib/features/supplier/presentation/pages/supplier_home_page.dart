import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '/shared/widgets/loading_widget.dart';
import '/shared/models/supplier_model.dart';
import '../../../../../core/services/tanker_service.dart';
import '../../../../shared/models/tanker_model.dart'; // Updated import
import '../widgets/home/tanker_card.dart';
import '../widgets/home/assign_driver_modal.dart';
import '../widgets/home/top_tab_selector.dart';
import '../widgets/supplier_bottom_nav.dart';

class SupplierHomePage extends StatefulWidget {
  const SupplierHomePage({super.key});

  @override
  State<SupplierHomePage> createState() => _SupplierHomePageState();
}

class _SupplierHomePageState extends State<SupplierHomePage> {
  int selectedIndex = 0;
  String selectedTab = "Available Tankers";

  List<TankerModel> tankerList = [];
  SupplierModel? supplier;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    // Temporary welcome until supplier profile endpoint is available
    supplier = SupplierModel(supplierId: '', name: 'Supplier');
    final resp = await TankerService().getTankers();
    if (mounted) {
      setState(() {
        tankerList = resp.data ?? [];
      });
    }
  }

  void assignDriver(TankerModel tanker) {
    showModalBottomSheet(
      context: context,
      builder: (_) => AssignDriverModal(
        onSelect: (driver) async {
          if (tanker.id != null) {
            await TankerService().assignDriver(tankerId: tanker.id!, driverId: driver.id!); // Changed driver.driverId to driver.id!
            await loadInitialData();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (supplier == null) {
    return const LoadingWidget();
  }
    List<TankerModel> filteredTankers = tankerList.where((t) {
      if (selectedTab == "Available Tankers") return t.status == 'Idle'; // Changed status
      if (selectedTab == "Active Tankers") return t.status == 'In Transit'; // Changed status
      if (selectedTab == "Disabled Tankers") return t.status == 'Under Maintenance'; // Changed status
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.black),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Welcome, ${supplier!.name}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _homeCard(context, 'Add Tanker', Icons.fire_truck, AppColors.primaryRed, '/add-truck', const Color(0xFFFCEEEE)),
                const SizedBox(width: 12),
                _homeCard(context, 'Add Driver', Icons.person_add, Colors.blue, '/add-driver', const Color(0xFFE5F6FD)),
              ],
            ),
          ),
          TopTabSelector(
            selectedTab: selectedTab,
            onSelect: (tab) => setState(() => selectedTab = tab),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTankers.length,
              itemBuilder: (context, index) {
                final tanker = filteredTankers[index];
                return TankerCard(
                  tanker: tanker,
                  selectedTab: selectedTab,
                  onAssignDriver: () => assignDriver(tanker),
                  onEnable: () async {
                    if (tanker.id != null) {
                      await TankerService().updateTanker(
                        tanker.id!,
                        TankerModel(
                          supplierId: tanker.supplierId!, // Reverted to !
                          tankerType: tanker.tankerType,
                          maxCapacity: tanker.maxCapacity,
                          allowedCapacity: tanker.allowedCapacity,
                          rcNumber: tanker.rcNumber,
                          insuranceNumber: tanker.insuranceNumber,
                          fcNumber: tanker.fcNumber,
                          npNumber: tanker.npNumber,
                          lpNumber: tanker.lpNumber,
                          taxExpiry: tanker.taxExpiry,
                          pollutionExpiry: tanker.pollutionExpiry,
                          vehicleNumber: tanker.vehicleNumber,
                          status: 'Idle', // Changed status
                        ),
                      );
                      await loadInitialData();
                    }
                  },
                  onDisable: () async {
                    if (tanker.id != null) {
                      await TankerService().updateTanker(
                        tanker.id!,
                        TankerModel(
                          supplierId: tanker.supplierId!, // Reverted to !
                          tankerType: tanker.tankerType,
                          maxCapacity: tanker.maxCapacity,
                          allowedCapacity: tanker.allowedCapacity,
                          rcNumber: tanker.rcNumber,
                          insuranceNumber: tanker.insuranceNumber,
                          fcNumber: tanker.fcNumber,
                          npNumber: tanker.npNumber,
                          lpNumber: tanker.lpNumber,
                          taxExpiry: tanker.taxExpiry,
                          pollutionExpiry: tanker.pollutionExpiry,
                          vehicleNumber: tanker.vehicleNumber,
                          status: 'Under Maintenance', // Changed status
                        ),
                      );
                      await loadInitialData();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SupplierBottomNav(selectedIndex: 0),
    );
  }

  Widget _homeCard(BuildContext context, String title, IconData icon, Color color, String route, Color bgColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(title, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}