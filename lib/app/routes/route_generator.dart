import 'package:flutter/material.dart';
import '../../../features/welcome/presentation/pages/welcome_page.dart';
import '../../../features/customer/presentation/pages/customer_login_page.dart';
import '../../../features/customer/presentation/pages/customer_home_page.dart';
import '../../../features/customer/presentation/pages/customer_orders_page.dart';
import '../../../features/customer/presentation/pages/customer_payments_page.dart';
import '../../../features/customer/presentation/pages/customer_track_page.dart';
import '../../features/customer/presentation/pages/customer_account_page.dart';

import '../../../features/driver/presentation/pages/driver_login_page.dart';
import '../../../features/driver/presentation/pages/driver_home_page.dart';
import '../../../features/driver/presentation/pages/driver_order_page.dart';

import '../../../features/supplier/presentation/pages/supplier_login_page.dart';
import '../../../features/supplier/presentation/pages/supplier_home_page.dart';
import '../../../features/supplier/presentation/pages/supplier_orders_page.dart';
import '../../../features/supplier/presentation/pages/supplier_payments_page.dart';
import '../../../features/supplier/presentation/pages/supplier_track_page.dart';
import '../../../features/supplier/presentation/pages/supplier_account_page.dart';
import '../../../features/supplier/presentation/pages/add_truck_page.dart';
import '../../../features/supplier/presentation/pages/add_driver_page.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case AppRoutes.customerLogin:
        return MaterialPageRoute(builder: (_) => const CustomerLoginPage());
      case AppRoutes.customerHome:
        return MaterialPageRoute(builder: (_) => const CustomerHomePage());
      case AppRoutes.customerOrders:
        return MaterialPageRoute(builder: (_) => const CustomerOrdersPage());
      case AppRoutes.customerPayments:
        return MaterialPageRoute(builder: (_) => const CustomerPaymentsPage());
      case AppRoutes.customerTrack:
        return MaterialPageRoute(builder: (_) => const CustomerTrackPage());
      case AppRoutes.customerAccount:
        return MaterialPageRoute(builder: (_) => const CustomerAccountPage());

      case AppRoutes.driverLogin:
        return MaterialPageRoute(builder: (_) => const DriverLoginPage());
      case AppRoutes.driverHome:
        return MaterialPageRoute(builder: (_) => const DriverHomePage());
      case AppRoutes.driverOrders:
      case AppRoutes.driverOrderDetails:
        return MaterialPageRoute(builder: (_) => const DriverOrderPage());

      case AppRoutes.supplierLogin:
        return MaterialPageRoute(builder: (_) => const SupplierLoginPage());
      case AppRoutes.supplierHome:
        return MaterialPageRoute(builder: (_) => const SupplierHomePage());
      case AppRoutes.supplierOrders:
        return MaterialPageRoute(builder: (_) => const SupplierOrdersPage());
      case AppRoutes.supplierPayments:
        return MaterialPageRoute(builder: (_) => const SupplierPaymentsPage());
      case AppRoutes.supplierTrack:
        return MaterialPageRoute(builder: (_) => const SupplierTrackPage());
      case AppRoutes.supplierAccount:
        return MaterialPageRoute(builder: (_) => const SupplierAccountPage());
      case AppRoutes.addTruck:
        return MaterialPageRoute(builder: (_) => const AddTruckPage());
      case AppRoutes.addDriver:
        return MaterialPageRoute(builder: (_) => const AddDriverPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page Not Found")),
          ),
        );
    }
  }
}
