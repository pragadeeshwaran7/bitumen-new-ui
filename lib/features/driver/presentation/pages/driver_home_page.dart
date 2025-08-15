import 'package:flutter/material.dart';
//import 'package:mobile_app/features/supplier/data/models/driver_model.dart';
import '../../../../../core/constants/app_colors.dart';
import '/shared/widgets/loading_widget.dart';
import '../widgets/home/driver_order_card.dart';
import '../widgets/home/driver_home_header.dart';
import '../widgets/home/driver_home_tabs.dart';
import '../widgets/driver_bottom_nav.dart';
import '../../data/models/driver_home_order.dart';
import 'package:mobile_app/shared/models/driver_model.dart';
import '../../data/services/driver_home_service.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  String selectedTab = 'New Orders';
  List<DriverHomeOrder> orders = [];
  DriverModel? driver;

  
  @override
  void initState() {
    super.initState();
    initializePageData(); // async method call
  }

  Future<void> initializePageData() async {
    final fetchedOrders = await DriverHomeApiService().fetchOrders();
    final fetchedDriver = await DriverHomeApiService().fetchDriverProfile();
    setState(() {
      orders = fetchedOrders;
      driver = fetchedDriver;
    });
  }

  List<DriverHomeOrder> getFilteredOrders() {
    return orders.where((o) {
      if (selectedTab == 'New Orders') return o.status == 'Pending';
      if (selectedTab == 'Active') return o.status == 'In Transit';
      if (selectedTab == 'Completed') return o.status == 'Completed';
      return false;
    }).toList();
  }

  void onTabChange(String tab) => setState(() => selectedTab = tab);

  void onAcceptOrder(String orderId) {
    DriverHomeApiService().acceptOrder(orderId);
    Navigator.pushNamed(context, '/driver-orders'); 
  }

  @override
  Widget build(BuildContext context) {
    if (driver == null) {
      return const LoadingWidget();
    }

    final filteredOrders = getFilteredOrders();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        elevation: 0.5,
        title: Text(
          "Hello, ${driver!.name}",
          style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DriverHomeHeader(driverId: driver!.driverId),
          DriverHomeTabs(selectedTab: selectedTab, onTabChange: onTabChange),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                return DriverOrderCard(
                  order: filteredOrders[index],
                  onAccept: onAcceptOrder,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const DriverBottomNav(selectedIndex: 0),
    );
  }
}
