import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/services/auth_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/permission_service.dart';
import '../core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isLoading = true;
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check for updates or refresh data when app comes to foreground
      _checkAuthStatus();
    }
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));

      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Check authentication status to determine initial route
      await _checkAuthStatus();
    } catch (e) {
      debugPrint('Error initializing app: $e');
      // Fallback to auth screen on error
      if (mounted) {
        setState(() {
          _initialRoute = AppRoutes.login;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final isAuthenticated = await authService.isAuthenticated();

      final locationStatus = await Permission.locationWhenInUse.status;
      if (!locationStatus.isGranted) {
        await PermissionService.requestLocationPermission();
      }

      final notificationService = Provider.of<NotificationService>(context, listen: false);
      final notificationStatus = await Permission.notification.status;
      if (!notificationStatus.isGranted) {
        await notificationService.requestNotificationPermission();
      }

      if (mounted) {
        setState(() {
          _initialRoute = isAuthenticated ? AppRoutes.home : AppRoutes.login;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      if (mounted) {
        setState(() {
          _initialRoute = AppRoutes.login;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Bitumen Hub',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
      ],
      initialRoute: _initialRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}