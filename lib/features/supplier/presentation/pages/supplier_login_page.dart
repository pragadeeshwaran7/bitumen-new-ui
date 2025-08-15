import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/common_login_form.dart';
import '../widgets/register/supplier_registration_form.dart';

class SupplierLoginPage extends StatefulWidget {
  const SupplierLoginPage({super.key});

  @override
  State<SupplierLoginPage> createState() => _SupplierLoginPageState();
}

class _SupplierLoginPageState extends State<SupplierLoginPage> {
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = AppColors.primaryRed;
    final Color unselectedColor = Colors.grey.shade300;

    return Scaffold(
      appBar: AppBar(title: const Text('Supplier Login/Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isRegister = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRegister ? unselectedColor : selectedColor,
                      foregroundColor: isRegister ? AppColors.black : AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isRegister = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRegister ? selectedColor : unselectedColor,
                      foregroundColor: isRegister ? AppColors.white : AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isRegister
                ? SupplierRegistrationForm(onRegistered: () {
                    setState(() => isRegister = false);
                  })
                : const CommonLoginForm(role: 'supplier'),
            const SizedBox(height: 30),
            const Text(
              'By continuing, you agree to our Terms & Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.greyText),
            )
          ],
        ),
      ),
    );
  }
}
