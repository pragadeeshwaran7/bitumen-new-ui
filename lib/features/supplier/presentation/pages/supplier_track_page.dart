import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/track_header_card.dart';
import '../../../../shared/widgets/track_map_view.dart';
import '../../../../shared/widgets/track_camera_view.dart';
import '../../../../shared/models/tracking.dart';
import '../../../../shared/services/tracking_service.dart';
import '../widgets/supplier_bottom_nav.dart';

class SupplierTrackPage extends StatefulWidget {
  const SupplierTrackPage({super.key});

  @override
  State<SupplierTrackPage> createState() => _SupplierTrackPageState();
}

class _SupplierTrackPageState extends State<SupplierTrackPage> {
  int selectedIndex = 3;
  Map<String, String> viewMode = {};
  late Future<List<Tracking>> _trackingFuture;

  @override
  void initState() {
    super.initState();
    _trackingFuture = TrackingApiService().fetchTrackingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Track Orders", style: TextStyle(color: AppColors.black)),
        iconTheme: const IconThemeData(color: AppColors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/supplier-home');
          },
        ),
        elevation: 0.4,
      ),
      body: FutureBuilder<List<Tracking>>(
        future: _trackingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading tracking data"));
          }

          final trackingOrders = snapshot.data!;
          if (trackingOrders.isEmpty) {
            return const Center(child: Text("No tracking orders found."));
          }

          return ListView(
            children: trackingOrders.map((order) {
              final mode = viewMode[order.trackingId];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with toggle buttons (map/camera)
                  TrackHeaderCard(
                    order: order,
                    mode: mode,
                    onViewModeChanged: (newMode) {
                      setState(() {
                        viewMode[order.trackingId] = newMode;
                      });
                    },
                  ),

                  // Conditionally show map or camera view
                  if (mode == 'map') TrackMapView(order: order),
                  if (mode == 'camera') TrackCameraView(cameraFeedUrl: order.cameraFeedUrl),

                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: const SupplierBottomNav(selectedIndex: 3),
    );
  }
}
