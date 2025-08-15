import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/models/tracking.dart';

class TrackMapView extends StatelessWidget {
  final Tracking order;

  const TrackMapView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final List<LatLng> coords = order.gpsCoordinates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Google Map with polyline and markers
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: coords.isNotEmpty ? coords.first : const LatLng(19.0760, 72.8777),
              zoom: 10,
            ),
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: coords,
                color: Colors.blue,
                width: 4,
              )
            },
            markers: {
              if (coords.isNotEmpty)
                Marker(markerId: const MarkerId('start'), position: coords.first),
              if (coords.length > 1)
                Marker(markerId: const MarkerId('end'), position: coords.last),
            },
            myLocationEnabled: false,
            zoomControlsEnabled: false,
          ),
        ),

        // Order Info
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pickup & Delivery locations
              Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: AppColors.primaryRed),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text("Pickup Location: ${order.pickup}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.circle_outlined, size: 10, color: AppColors.primaryRed),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text("Delivery Location: ${order.delivery}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Live Updates Header
              const Text('Live Tracking Updates:',
                  style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              // Scrollable Updates List
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ListView.builder(
                  itemCount: order.updates.length,
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.green, size: 16),
                        const SizedBox(width: 6),
                        Expanded(child: Text(order.updates[index])),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
