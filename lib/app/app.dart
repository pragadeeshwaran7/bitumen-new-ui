import 'package:flutter/material.dart';
import 'routes/route_generator.dart';
import 'routes/app_routes.dart';

class BitTruckApp extends StatelessWidget {
  const BitTruckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitumen Hub',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.red,
      ),
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
