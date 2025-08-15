import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import 'package:mobile_app/features/customer/presentation/pages/customer_login_page.dart';
import 'package:mobile_app/features/driver/presentation/pages/driver_login_page.dart';
import 'package:mobile_app/features/supplier/presentation/pages/supplier_login_page.dart';
import '../widgets/role_selection_card.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.red,
              child: Icon(Icons.local_shipping, size: 50, color: AppColors.white),
            ),
            const SizedBox(height: 20),
            const Text('Bitumen Hub',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Logistics & Transportation',
                style: TextStyle(color: AppColors.greyText)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('Welcome',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text('Choose how you want to continue',
                          style: TextStyle(color: AppColors.greyText)),
                      const SizedBox(height: 20),
                      RoleSelectionCard(
                        icon: Icons.person_outline,
                        label: "Continue as Customer",
                        onTap: () => navigateTo(context, const CustomerLoginPage()),
                      ),
                      const SizedBox(height: 10),
                      RoleSelectionCard(
                        icon: Icons.local_shipping_outlined,
                        label: "Continue as Tanker Driver",
                        onTap: () => navigateTo(context, const DriverLoginPage()),
                      ),
                      const SizedBox(height: 10),
                      RoleSelectionCard(
                        icon: Icons.fire_truck,
                        label: "Continue as Tanker Supplier",
                        onTap: () => navigateTo(context, const SupplierLoginPage()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'By continuing, you agree to our Terms of Service and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.greyText),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
