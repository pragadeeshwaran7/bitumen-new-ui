import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/account_info_tile.dart';
import '../../../../shared/widgets/account_setting_tile.dart';
import '../widgets/supplier_bottom_nav.dart';
import '../../data/models/supplier_profile.dart';
import '../../data/services/supplier_profile_service.dart';

class SupplierAccountPage extends StatefulWidget {
  const SupplierAccountPage({super.key});

  @override
  State<SupplierAccountPage> createState() => _SupplierAccountPageState();
}

class _SupplierAccountPageState extends State<SupplierAccountPage> {
  late Future<SupplierProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = SupplierProfileApiService().fetchSupplierProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Account", style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/supplier-home');
          },
        ),
      ),
      body: FutureBuilder<SupplierProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading profile"));
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primaryRed,
                  child: Icon(Icons.person, size: 35, color: AppColors.white),
                ),
                const SizedBox(height: 10),
                Text(profile.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(profile.company, style: const TextStyle(color: AppColors.greyText)),
                const SizedBox(height: 20),

                // Personal Info Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Information",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    children: [
                      AccountInfoTile(icon: Icons.phone, text: profile.phone),
                      const Divider(),
                      AccountInfoTile(icon: Icons.email, text: profile.email),
                      const Divider(),
                      AccountInfoTile(icon: Icons.location_on, text: profile.address),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Settings Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                const AccountSettingTile(icon: Icons.settings, title: "App Settings"),
                const AccountSettingTile(icon: Icons.lock, title: "Privacy & Security"),
                const AccountSettingTile(icon: Icons.help_outline, title: "Help & Support"),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const SupplierBottomNav(selectedIndex: 4),
    );
  }
}
