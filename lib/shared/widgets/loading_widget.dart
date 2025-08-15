import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set background color
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
