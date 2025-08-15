import 'package:flutter/material.dart';

class TrackCameraView extends StatelessWidget {
  final String? cameraFeedUrl;

  const TrackCameraView({super.key, required this.cameraFeedUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: cameraFeedUrl != null
          ? Image.network(cameraFeedUrl!, fit: BoxFit.cover)
          : const Center(
              child: Icon(Icons.videocam_off, size: 50, color: Colors.black38),
            ),
    );
  }
}

