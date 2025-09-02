import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_colors.dart';
import '../widgets/order/driver_order_location_card.dart';
import '../widgets/order/driver_order_detail_row.dart';
import '../widgets/driver_bottom_nav.dart';
import '../../data/models/driver_order.dart';
import '../../data/services/driver_order_service.dart';

class DriverOrderPage extends StatefulWidget {
  const DriverOrderPage({super.key});

  @override
  State<DriverOrderPage> createState() => _DriverOrderPageState();
}

class _DriverOrderPageState extends State<DriverOrderPage> {
  late Future<DriverOrder?> _orderFuture;

  final TextEditingController pickupOtpController = TextEditingController();
  final TextEditingController dropOtpController = TextEditingController();

  File? billImage;
  bool rideStarted = false;
  bool rideCompleted = false;

  @override
  void initState() {
    super.initState();
    _orderFuture = DriverOrderApiService().fetchDriverOrder();
  }

  Future<void> pickBillImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => billImage = File(picked.path));
      await DriverOrderApiService().uploadBill(billImage!);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Mock Bill Uploaded")));
    }
  }

  Future<void> verifyOtp(String type, String orderId) async {
    final controller =
        type == 'pickup' ? pickupOtpController : dropOtpController;
    final verified = await DriverOrderApiService().verifyOtp(
      type,
      controller.text,
    );
    if (verified) {
      setState(() {
        if (type == 'pickup') rideStarted = true;
        if (type == 'drop') rideCompleted = true;
      });

      if (type == 'drop') {
        // await DriverOrderApiService().completeDriverOrder(orderId);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${type[0].toUpperCase()}${type.substring(1)} OTP Verified.",
          ),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  Future<void> callCustomer(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.black),
        title: const Text(
          "Order Details",
          style: TextStyle(color: AppColors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              () => Navigator.pushReplacementNamed(context, '/driver-home'),
        ),
        actions: [
          IconButton(
            onPressed: pickBillImage,
            icon: const Icon(
              Icons.document_scanner,
              color: AppColors.primaryRed,
            ),
            tooltip: "Scan and Upload Bill",
          ),
        ],
      ),
      body: FutureBuilder<DriverOrder?>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show "No order found" if null (order is completed)
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "No order found",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }
          final order = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.customerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(order.customerPhone),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => callCustomer(order.customerPhone),
                        icon: const Icon(
                          Icons.call,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                DriverOrderLocationCard(
                  title: "PICKUP",
                  location: order.pickupLocation,
                  address: order.pickupAddress,
                  color: AppColors.primaryRed,
                  showOtp: !rideStarted,
                  controller: pickupOtpController,
                  onVerify: () => verifyOtp('pickup', order.orderId),
                  verified: rideStarted,
                ),
                DriverOrderLocationCard(
                  title: "DELIVERY",
                  location: order.dropLocation,
                  address: order.dropAddress,
                  color: AppColors.orange,
                  showOtp: rideStarted && !rideCompleted,
                  controller: dropOtpController,
                  onVerify: () => verifyOtp('drop', order.orderId),
                  verified: rideCompleted,
                ),

                const SizedBox(height: 16),
                const Text(
                  "Order Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children: [
                      DriverOrderDetailRow(
                        title: "Bitumen Type",
                        value: order.bitumenType,
                      ),
                      DriverOrderDetailRow(
                        title: "Quantity at Loading",
                        value: order.quantityLoading,
                      ),
                      DriverOrderDetailRow(
                        title: "Quantity at Unloading",
                        value: order.quantityUnloading,
                      ),
                      DriverOrderDetailRow(
                        title: "Total Distance",
                        value: order.distance,
                      ),
                    ],
                  ),
                ),

                if (rideCompleted) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Order Completed",
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const DriverBottomNav(selectedIndex: 1),
    );
  }
}
