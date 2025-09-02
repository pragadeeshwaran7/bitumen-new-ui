class AppRoutes {
  // Common routes
  static const String splash = '/splash';
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  // Customer routes
  static const String customerLogin = '/customer/login';
  static const String customerHome = '/customer/home';
  static const String customerOrders = '/customer/orders';
  static const String customerPayments = '/customer/payments';
  static const String customerTrack = '/customer/track';
  static const String customerAccount = '/customer/account';

  static const String createOrder = '/customer/orders/create';

  // Driver routes
  static const String driverLogin = '/driver/login';
  static const String driverHome = '/driver/home';
  static const String driverOrders = '/driver/orders';
  static const String driverOrderDetails = '/driver/orders/details';

  // Supplier routes
  static const String supplierLogin = '/supplier/login';
  static const String supplierHome = '/supplier/home';
  static const String supplierOrders = '/supplier/orders';
  static const String supplierPayments = '/supplier/payments';
  static const String supplierTrack = '/supplier/track';
  static const String supplierAccount = '/supplier/account';
  static const String addTruck = '/supplier/trucks/add';
  static const String addDriver = '/supplier/drivers/add';
}