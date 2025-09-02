import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../shared/models/tracking.dart';

class TrackingApiService {
  static final TrackingApiService _instance = TrackingApiService._internal();
  factory TrackingApiService() => _instance;
  TrackingApiService._internal();

  final List<Tracking> _mockTrackingOrders = [
    Tracking(
      trackingId: 'TR123456789',
      status: 'In Transit',
      eta: '2 hrs 15 mins',
      pickup: 'Mumbai, Maharashtra',
      delivery: 'Pune, Maharashtra',
      updates: [
        'Pickup Point Confirmed',
        'Loading',
        'In Transit',
        'Reached Drop Point',
        'Unloading',
        'Delivered',
      ],
      gpsCoordinates: [
        LatLng(19.0760, 72.8777),
        LatLng(18.5204, 73.8567),
      ],
      cameraFeedUrl: 'https://example.com/mock-feed.mp4',
    ),
  ];

  Future<List<Tracking>> fetchTrackingOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTrackingOrders;
  }

  // TODO: Replace with real backend logic using Dio and ApiHelper.
}
