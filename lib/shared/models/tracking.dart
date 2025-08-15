import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracking {
  final String trackingId;
  final String status;
  final String eta;
  final String pickup;
  final String delivery;
  final List<String> updates;
  final List<LatLng> gpsCoordinates;     // New field
  final String? cameraFeedUrl;

  Tracking({
    required this.trackingId,
    required this.status,
    required this.eta,
    required this.pickup,
    required this.delivery,
    required this.updates,
    required this.gpsCoordinates,
    this.cameraFeedUrl,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      trackingId: json['tracking_id'],
      status: json['status'],
      eta: json['eta'],
      pickup: json['pickup'],
      delivery: json['delivery'],
      updates: List<String>.from(json['updates']),
      gpsCoordinates: (json['gpsCoordinates'] as List)
          .map((c) => LatLng(c['lat'], c['lng']))
          .toList(),
      cameraFeedUrl: json['cameraFeedUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tracking_id': trackingId,
      'status': status,
      'eta': eta,
      'pickup': pickup,
      'delivery': delivery,
      'updates': updates,
      'gpsCoordinates': gpsCoordinates
            .map((c) => {'lat': c.latitude, 'lng': c.longitude})
            .toList(),
        'cameraFeedUrl': cameraFeedUrl,
    };
  }
}
