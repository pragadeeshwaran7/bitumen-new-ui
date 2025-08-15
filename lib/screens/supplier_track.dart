import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SupplierTrackPage extends StatefulWidget {
  const SupplierTrackPage({super.key});

  @override
  State<SupplierTrackPage> createState() => _SupplierTrackPageState();
}

class _SupplierTrackPageState extends State<SupplierTrackPage> {
  int selectedIndex = 3;

  /// Track per-order view state (map or camera)
  Map<String, String> viewMode = {};

  /// Placeholder order tracking data
  final List<Map<String, dynamic>> trackingOrders = [
    {
      'tracking_id': 'TR123456789',
      'status': 'In Transit',
      'eta': '2 hrs 15 mins',
      'pickup': 'Mumbai, Maharashtra',
      'delivery': 'Pune, Maharashtra',
      'updates': [
        'Pickup Point Confirmed',
        'Loading',
        'In Transit',
        'Reached Drop Point',
        'Unloading',
        'Delivered',
      ]
    }
  ];

  void onBottomBarTap(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/supplier-home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/supplier-orders');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/supplier-payments');
        break;
      case 3:
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/supplier-account');
        break;
    }
  }

  Widget buildHeaderCard(Map<String, dynamic> order) {
    final mode = viewMode[order['tracking_id']];
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Tracking ID", style: TextStyle(color: Colors.grey)),
        Text(order['tracking_id'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Status", style: TextStyle(color: Colors.grey)),
              Text(order['status'],
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("ETA", style: TextStyle(color: Colors.grey)),
              Text(order['eta'],
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    viewMode[order['tracking_id']] = 'map';
                  });
                },
                icon: const Icon(Icons.location_on_outlined),
                label: const Text('Map View'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mode == 'map' ? Colors.red : Colors.grey[300],
                  foregroundColor: mode == 'map' ? Colors.white : Colors.black,
                  minimumSize: const Size.fromHeight(45),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    viewMode[order['tracking_id']] = 'camera';
                  });
                },
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Camera View'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      mode == 'camera' ? Colors.red : Colors.grey[300],
                  foregroundColor: mode == 'camera' ? Colors.white : Colors.black,
                  minimumSize: const Size.fromHeight(45),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget buildMapView(Map<String, dynamic> order) {
    return Column(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(19.0760, 72.8777), // Mumbai
              zoom: 10,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.circle, size: 10, color: Colors.red),
                const SizedBox(width: 6),
                Text("Pickup Location: ${order['pickup']}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.circle_outlined, size: 10, color: Colors.red),
                const SizedBox(width: 6),
                Text("Delivery Location: ${order['delivery']}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 16),
              const Text('Tracking Updates:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ...order['updates'].map<Widget>((step) => Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green, size: 16),
                      const SizedBox(width: 6),
                      Text(step),
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCameraView() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.videocam, color: Colors.black38, size: 50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Track Orders", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.4,
      ),
      body: ListView(
        children: trackingOrders.map((order) {
          final mode = viewMode[order['tracking_id']];
          return Column(
            children: [
              buildHeaderCard(order),
              if (mode == 'map') buildMapView(order),
              if (mode == 'camera') buildCameraView(),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onBottomBarTap,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes), label: 'Track Order'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}
