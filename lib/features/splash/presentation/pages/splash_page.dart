import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/profile_service.dart';
import '../../../../app/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    final auth = AuthService();
    final token = await auth.getToken();
    String route = AppRoutes.welcome;
    if (token != null) {
      final profileService = ProfileService();
      final profileResp = await profileService.getProfile();
      if (profileResp.success) {
        final user = profileResp.data;
        final role = user['role']?.toString().toLowerCase() ?? '';
        if (role == 'customer') {
          route = AppRoutes.customerHome;
        } else if (role == 'driver') {
          route = AppRoutes.driverHome;
        } else if (role == 'supplier') {
          route = AppRoutes.supplierHome;
        }
      }
    }
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
