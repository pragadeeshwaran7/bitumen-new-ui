import 'dart:io';
import '../../../../../core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TruckFileUpload extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onPressed;

  const TruckFileUpload({
    super.key,
    required this.label,
    required this.file,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.upload_file),
            label: Text(label),
          ),
          const SizedBox(width: 10),
          Text(
            file != null ? 'File Selected' : 'No File',
            style: const TextStyle(color: AppColors.greyText),
          ),
        ],
      ),
    );
  }
}
