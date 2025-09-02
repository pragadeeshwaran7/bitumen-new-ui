import 'package:bitumen_hub/screens/supplier_orders_screen.dart';
import 'package:bitumen_hub/screens/add_driver.dart';
import 'package:bitumen_hub/screens/add_tanker.dart';
import 'package:bitumen_hub/screens/customer_account.dart';
import 'package:bitumen_hub/screens/customer_home.dart';
import 'package:bitumen_hub/screens/customer_payments.dart';
import 'package:bitumen_hub/screens/customer_track.dart';
import 'package:bitumen_hub/screens/driver_home.dart';
import 'package:bitumen_hub/screens/driver_order.dart';
import 'package:bitumen_hub/screens/login_screen.dart';
import 'package:bitumen_hub/screens/register_screen.dart';
import 'package:bitumen_hub/screens/supplier_account.dart';
import 'package:bitumen_hub/screens/supplier_home.dart';
import 'package:bitumen_hub/screens/supplier_payments.dart';
import 'package:bitumen_hub/screens/supplier_track.dart';
import 'package:bitumen_hub/screens/welcome_screen.dart';
import 'package:bitumen_hub/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.createOrder:
        return MaterialPageRoute(builder: (_) => const CreateOrderScreen());

      case AppRoutes.customerHome:
        return MaterialPageRoute(builder: (_) => const CustomerHomePage());
      case AppRoutes.customerPayments:
        return MaterialPageRoute(builder: (_) => const CustomerPaymentsPage());
      case AppRoutes.customerTrack:
        return MaterialPageRoute(builder: (_) => const CustomerTrackPage());
      case AppRoutes.customerAccount:
        return MaterialPageRoute(builder: (_) => const CustomerAccountPage());

      case AppRoutes.driverHome:
        return MaterialPageRoute(builder: (_) => const DriverHomePage());
      case AppRoutes.driverOrders:
        return MaterialPageRoute(builder: (_) => const DriverOrderPage());

      case AppRoutes.supplierHome:
        return MaterialPageRoute(builder: (_) => const SupplierHomePage());
      case AppRoutes.supplierOrders:
        return MaterialPageRoute(builder: (_) => const SupplierOrdersScreen());
      case AppRoutes.supplierPayments:
        return MaterialPageRoute(builder: (_) => const SupplierPaymentsPage());
      case AppRoutes.supplierTrack:
        return MaterialPageRoute(builder: (_) => const SupplierTrackPage());
      case AppRoutes.supplierAccount:
        return MaterialPageRoute(builder: (_) => const SupplierAccountPage());
      case AppRoutes.addDriver:
        return MaterialPageRoute(builder: (_) => const AddDriverPage());
      case AppRoutes.addTruck:
        return MaterialPageRoute(builder: (_) => const AddTankerPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page Not Found")),
          ),
        );
    }
  }
}