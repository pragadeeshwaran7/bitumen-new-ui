import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '/shared/widgets/loading_widget.dart';
import '../../data/models/tanker_model.dart';
import '/shared/models/supplier_model.dart';
import '../../data/services/tanker_api_service.dart';
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

  List<Tanker> tankerList = [];
  SupplierModel? supplier;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final profile = await TankerApiService().fetchSupplierProfile();
    final data = await TankerApiService().fetchTankers();
    setState(() {
      supplier = profile;
      tankerList = data;
    });
  }

  void assignDriver(Tanker tanker) {
    showModalBottomSheet(
      context: context,
      builder: (_) => AssignDriverModal(
        onSelect: (driver) async {
          await TankerApiService().assignDriver(tanker.tankerNo, driver['name']!, driver['phone']!);
          loadInitialData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (supplier == null) {
    return const LoadingWidget();
  }
    List<Tanker> filteredTankers = tankerList.where((t) {
      if (selectedTab == "Available Tankers") return t.status == 'Available';
      if (selectedTab == "Active Tankers") return t.status == 'In Transit';
      if (selectedTab == "Disabled Tankers") return t.status == 'In Service';
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
                  tanker: tanker.toJson(),
                  selectedTab: selectedTab,
                  onAssignDriver: () => assignDriver(tanker),
                  onEnable: () async {
                    await TankerApiService().updateStatus(tanker.tankerNo, 'Available');
                    loadInitialData();
                  },
                  onDisable: () async {
                    await TankerApiService().updateStatus(tanker.tankerNo, 'In Service');
                    loadInitialData();
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
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
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
