import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../widgets/home/initial_view.dart';
import '../widgets/home/booking_view.dart';
import '../widgets/home/payment_view.dart';
import '../widgets/home/success_view.dart';
import '../widgets/customer_bottom_nav.dart';
import '../../../../shared/models/order_model.dart';
import '../../data/services/customer_order_service.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int selectedIndex = 0;
  int viewStep = -1;

  String username = "Hariharan";
  String selectedTanker = "Small Tanker";
  String selectedGoods = "VG30";
  int loadingQty = 20;
  int unloadingQty = 20;
  int totalDistance = 42;
  int ratePerKm = 25;
  String selectedPaymentMethod = "Net Banking";

  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final receiverNameController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final receiverEmailController = TextEditingController();

  final trucks = {
    "Small Tanker": {"range": "10-15 Tons", "rate": 20},
    "Medium Tanker": {"range": "16-25 Tons", "rate": 22},
    "Large Tanker": {"range": "26-35 Tons", "rate": 25},
  };

  final goodsOptions = [
    "PMB", "CRMB", "VG30", "VG40", "RS1", "RS2", "SS1", "SS2", "MR"
  ];

  OrderModel? lastOrder;

  int calculateTotal() => (trucks[selectedTanker]!["rate"] as int) * totalDistance;
  int calculateAdvance() => (calculateTotal() * 0.75).round();

  void proceedToPayment() => setState(() => viewStep = 1);

  void makePayment() async {
    final order = OrderModel(
      pickupLocation: pickupController.text,
      dropLocation: dropController.text,
      pickupDate: DateTime.now(), // You may want to use a real date picker
      dropDate: DateTime.now(),   // You may want to use a real date picker
      receiverName: receiverNameController.text,
      receiverPhone: receiverPhoneController.text,
      receiverEmail: receiverEmailController.text,
      goodsType: selectedGoods,
      quantityAtLoading: loadingQty.toDouble(),
      quantityAtUnloading: unloadingQty.toDouble(),
      tankerType: selectedTanker,
      distance: totalDistance.toDouble(),
      ratePerKm: ratePerKm.toDouble(),
      paymentMethod: selectedPaymentMethod,
      totalAmount: calculateTotal().toDouble(),
      advanceAmount: calculateAdvance().toDouble(),
      balanceAmount: (calculateTotal() - calculateAdvance()).toDouble(),
      status: "Confirmed",
    );

    await CustomerApiService().createOrder(order);
    setState(() {
      lastOrder = order;
      viewStep = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.black),
        leading: viewStep == -1
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  viewStep = viewStep == 2 ? -1 : viewStep - 1;
                }),
              ),
      ),
      body: switch (viewStep) {
        -1 => InitialView(username: username, onTap: () => setState(() => viewStep = 0)),
         0 => BookingView(
                  selectedTanker: selectedTanker,
                  selectedGoods: selectedGoods,
                  loadingQty: loadingQty,
                  unloadingQty: unloadingQty,
                  pickupController: pickupController,
                  dropController: dropController,
                  receiverNameController: receiverNameController,
                  receiverPhoneController: receiverPhoneController,
                  receiverEmailController: receiverEmailController,
                  trucks: trucks,
                  goodsOptions: goodsOptions,
                  ratePerKm: ratePerKm,
                  totalDistance: totalDistance,
                  calculateAdvance: calculateAdvance,
                  calculateTotal: calculateTotal,
                  onQtyChange: (type, val) => setState(() {
                    if (type == "loading") loadingQty = val;
                    if (type == "unloading") unloadingQty = val;
                  }),
                  onTankerChange: (val) => setState(() {
                    selectedTanker = val;
                    ratePerKm = trucks[val]!["rate"] as int;
                  }),
                  onGoodsChange: (val) => setState(() => selectedGoods = val),
                  onProceed: proceedToPayment,
                ),
         1 => PaymentView(
                  total: calculateTotal(),
                  advance: calculateAdvance(),
                  balance: calculateTotal() - calculateAdvance(),
                  selectedMethod: selectedPaymentMethod,
                  onMethodChange: (val) => setState(() => selectedPaymentMethod = val),
                  onConfirm: makePayment,
                  onPay: () => setState(() => viewStep = 2),
                ),
         2 => lastOrder != null
              ? SuccessView(
                  order: lastOrder!,
                  onBackToHome: () => setState(() => viewStep = -1),
               )
              : Center(child: Text('No order found.')),
         _ => Container(),
      },
      bottomNavigationBar: const CustomerBottomNav(selectedIndex: 0),
    );
  }
}
