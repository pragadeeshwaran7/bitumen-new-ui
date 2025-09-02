import 'package:bitumen_hub/core/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'core/services/auth_service.dart';
import 'core/services/profile_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/permission_service.dart';
import 'core/services/driver_service.dart';
import 'core/services/payment_service.dart';
import 'core/services/tanker_service.dart';
import 'core/theme/app_theme.dart';

// Global navigator key for navigation without BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  try {
    // Initialize services
    final authService = AuthService();
    final profileService = ProfileService();
    final notificationService = NotificationService();
    final permissionService = PermissionService();
    final driverService = DriverService();
    final paymentService = PaymentService();
    final tankerService = TankerService();
    final orderService = OrderService();
    
    // Initialize auth state
    await authService.initAuth();
    
    // Initialize other services
    await profileService.initialize();
    await permissionService.initialize();
    await driverService.initialize();
    await paymentService.initialize();
    await tankerService.initialize();
    
    // Initialize notifications
    await notificationService.initialize();
    
    // Request necessary permissions
    await _requestPermissions();
    
    // Run the app with providers
    runApp(
      MultiProvider(
        providers: [
          Provider<AuthService>.value(value: authService),
          Provider<ProfileService>.value(value: profileService),
          Provider<NotificationService>.value(value: notificationService),
          Provider<PermissionService>.value(value: permissionService),
          Provider<DriverService>.value(value: driverService),
          Provider<PaymentService>.value(value: paymentService),
          Provider<TankerService>.value(value: tankerService),
          Provider<OrderService>.value(value: orderService),
          Provider<SharedPreferences>.value(value: prefs),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    // Handle any initialization errors
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Initialization error: $e'),
          ),
        ),
      ),
    );
  }
}

Future<void> _requestPermissions() async {
  try {
    // Request all required permissions
    await PermissionService.requestAllPermissions();
    
    // Additional permission initialization can go here
    await Future.wait([
      // Add any other permission requests here
    ]);
  } catch (e) {
    debugPrint('Error requesting permissions: $e');
  }
}
