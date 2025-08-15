import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverOrderPage extends StatefulWidget {
  const DriverOrderPage({super.key});

  @override
  State<DriverOrderPage> createState() => _DriverOrderPageState();
}

class _DriverOrderPageState extends State<DriverOrderPage> {
  // Mock data – replace with MongoDB API data
  final String orderId = "ORD2001";
  final String customerName = "Amit Sharma";
  final String customerPhone = "+91 98765 43210";
  final String pickupLocation = "Vashi, Navi Mumbai";
  final String pickupAddress = "Chandivali, Powai, Mumbai - 400072";
  final String dropLocation = "Panvel, Raigad";
  final String dropAddress = "MIDC Phase 2, Dombivli East, Thane - 421204";
  final String bitumenType = "VG40";
  final String quantityLoading = "20 Tons";
  final String quantityUnloading = "20 Tons";
  final String distance = "32 km";

  final TextEditingController pickupOtpController = TextEditingController();
  final TextEditingController dropOtpController = TextEditingController();

  File? billImage;
  bool rideStarted = false;
  bool rideCompleted = false;

  Future<void> pickBillImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        billImage = File(picked.path);
      });

      // TODO: Upload billImage to MongoDB via backend API
    }
  }

  void verifyPickupOtp() {
    // TODO: Replace with actual OTP verification logic via API
    if (pickupOtpController.text == '1234') {
      setState(() => rideStarted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pickup OTP Verified. Ride Started.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Pickup OTP")),
      );
    }
  }

  void verifyDropOtp() {
    // TODO: Replace with actual OTP verification logic via API
    if (dropOtpController.text == '5678') {
      setState(() => rideCompleted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Drop OTP Verified. Ride Completed.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Drop OTP")),
      );
    }
  }

  void callCustomer() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: customerPhone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text("Order #$orderId", style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: pickBillImage,
            icon: const Icon(Icons.document_scanner, color: Colors.red),
            tooltip: "Scan and Upload Bill",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Customer Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/user.png'), // Replace as needed
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(customerPhone),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: callCustomer,
                  icon: const Icon(Icons.call, color: Colors.red),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Pickup & Drop
          buildLocationCard(
            title: "PICKUP",
            location: pickupLocation,
            address: pickupAddress,
            color: Colors.red,
            showOtp: !rideStarted,
            controller: pickupOtpController,
            onVerify: verifyPickupOtp,
            verified: rideStarted,
          ),
          buildLocationCard(
            title: "DELIVERY",
            location: dropLocation,
            address: dropAddress,
            color: Colors.yellow[800]!,
            showOtp: rideStarted && !rideCompleted,
            controller: dropOtpController,
            onVerify: verifyDropOtp,
            verified: rideCompleted,
          ),

          const SizedBox(height: 16),

          // Order Details
          const Text("Order Details", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(children: [
              buildRow("Bitumen Type", bitumenType),
              buildRow("Quantity at Loading", quantityLoading),
              buildRow("Quantity at Unloading", quantityUnloading),
              buildRow("Total Distance", distance),
            ]),
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
                child: Text("Order Completed",
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            )
          ]
        ]),
      ),
    );
  }

  Widget buildLocationCard({
    required String title,
    required String location,
    required String address,
    required Color color,
    required bool showOtp,
    required TextEditingController controller,
    required VoidCallback onVerify,
    required bool verified,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Icon(Icons.circle, size: 10, color: color),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text(location, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Text(address, style: const TextStyle(color: Colors.grey)),
        if (showOtp) ...[
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter OTP",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onVerify,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Verify OTP"),
          )
        ],
        if (verified)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("Verified",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          )
      ]),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
