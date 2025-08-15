import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class AddTankerPage extends StatefulWidget {
  const AddTankerPage({super.key});

  @override
  State<AddTankerPage> createState() => _AddTankerPageState();
}

class _AddTankerPageState extends State<AddTankerPage> {
  final TextEditingController tankerNumberController = TextEditingController();
  final TextEditingController tankerTypeController = TextEditingController();
  final TextEditingController maxCapacityController = TextEditingController();
  final TextEditingController permissibleLimitController =
      TextEditingController();
  final TextEditingController rcNumberController = TextEditingController();
  final TextEditingController insuranceNumberController =
      TextEditingController();
  final TextEditingController fcNumberController = TextEditingController();
  final TextEditingController npNumberController = TextEditingController();

  DateTime? rcExpiryDate;
  DateTime? insuranceExpiryDate;
  DateTime? fcExpiryDate;
  DateTime? npExpiryDate;

  File? rcFile;
  File? insuranceFile;
  File? fcFile;
  File? npFile;

  final String supplierId = '682d5711189f527b226c4bef';
  final String driverId = '682d5711189f527b226c4bf0';

  Future<void> pickRCFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        rcFile = File(picked.path);
      });
    }
  }

  Future<void> pickInsuranceFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        insuranceFile = File(picked.path);
      });
    }
  }

  Future<void> pickFCFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        fcFile = File(picked.path);
      });
    }
  }

  Future<void> pickNPFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        npFile = File(picked.path);
      });
    }
  }

  Future<void> pickDate(BuildContext context, bool isRCDate) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        if (isRCDate) {
          rcExpiryDate = picked;
        } else {
          insuranceExpiryDate = picked;
        }
      });
    }
  }

  Future<void> addTanker() async {
    final uri = Uri.parse(
      'http://10.0.2.2:5000/api/tankers',
    ); // Replace when backend ready
    final request = http.MultipartRequest('POST', uri);

    request.fields['supplier_id'] = supplierId;
    request.fields['tanker_number'] = tankerNumberController.text;
    request.fields['tanker_type'] = tankerTypeController.text;
    request.fields['max_capacity'] = maxCapacityController.text;
    request.fields['permissible_limit'] = permissibleLimitController.text;
    request.fields['rc_number'] = rcNumberController.text;
    request.fields['rc_expiry'] = rcExpiryDate?.toIso8601String() ?? '';
    request.fields['insurance_number'] = insuranceNumberController.text;
    request.fields['insurance_expiry'] =
        insuranceExpiryDate?.toIso8601String() ?? '';
    request.fields['fc_number'] = fcNumberController.text;
    request.fields['fc_expiry'] = fcExpiryDate?.toIso8601String() ?? '';
    request.fields['np_number'] = npNumberController.text;
    request.fields['np_expiry'] = npExpiryDate?.toIso8601String() ?? '';
    request.fields['visible_to_customer'] = 'true';
    request.fields['status'] = 'Available';
    request.fields['driver_id'] = driverId;
    request.fields['location.lat'] = '';
    request.fields['location.lng'] = '';

    if (rcFile != null) {
      final mimeType = lookupMimeType(rcFile!.path)!.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'rc_document',
          rcFile!.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );
    }

    if (insuranceFile != null) {
      final mimeType = lookupMimeType(insuranceFile!.path)!.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'insurance_document',
          insuranceFile!.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );
    }

    if (fcFile != null) {
      final mimeType = lookupMimeType(fcFile!.path)!.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'fc_document',
          fcFile!.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );
    }

    if (npFile != null) {
      final mimeType = lookupMimeType(npFile!.path)!.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'np_document',
          npFile!.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tanker added successfully")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add tanker")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Tanker"), leading: BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Tanker",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            buildInput("Tanker Number", tankerNumberController),
            buildInput("Tanker Type", tankerTypeController),
            buildInput("Maximum Capacity", maxCapacityController),
            buildInput(
              "Permissible Limit (as per standards)",
              permissibleLimitController,
            ),
            buildInput("RC Number", rcNumberController),

            buildDateSelector(
              "RC Expiry Date",
              rcExpiryDate,
              () => pickDate(context, true),
            ),
            buildFileUpload("Upload RC Document", rcFile, pickRCFile),

            buildInput("Insurance Number", insuranceNumberController),
            buildDateSelector(
              "Insurance Expiry Date",
              insuranceExpiryDate,
              () => pickDate(context, false),
            ),
            buildFileUpload(
              "Upload Insurance Document",
              insuranceFile,
              pickInsuranceFile,
            ),
            buildInput("FC Number", fcNumberController),
            buildDateSelector(
              "FC Expiry Date",
              fcExpiryDate,
              () => pickDate(context, false),
            ),
            buildFileUpload("Upload FC Document", fcFile, pickFCFile),

            buildInput("National Permit Number", npNumberController),
            buildDateSelector(
              "National Permit Expiry Date",
              npExpiryDate,
              () => pickDate(context, false),
            ),
            buildFileUpload(
              "Upload National Permit Document",
              npFile,
              pickNPFile,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTanker,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Add Tanker"),
            ),

            const SizedBox(height: 30),
            const Text(
              'By continuing, you agree to our Terms & Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            date != null ? DateFormat.yMMMd().format(date) : 'Select Date',
          ),
        ),
      ),
    );
  }

  Widget buildFileUpload(String label, File? file, VoidCallback onPressed) {
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
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
