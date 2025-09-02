import 'package:bitumen_hub/core/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupLocationController = TextEditingController();
  final _dropoffLocationController = TextEditingController();
  final _quantityController = TextEditingController();
  final _productController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _pickupLocationController.dispose();
    _dropoffLocationController.dispose();
    _quantityController.dispose();
    _productController.dispose();
    super.dispose();
  }

  Future<void> _createOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final orderService = Provider.of<OrderService>(context, listen: false);
      final response = await orderService.createOrder(
        pickupLocation: _pickupLocationController.text,
        dropoffLocation: _dropoffLocationController.text,
        quantity: double.parse(_quantityController.text),
        product: _productController.text,
      );
      setState(() {
        _isLoading = false;
      });
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order created successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error ?? 'Failed to create order')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _pickupLocationController,
                decoration: const InputDecoration(labelText: 'Pickup Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pickup location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dropoffLocationController,
                decoration: const InputDecoration(labelText: 'Drop-off Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a drop-off location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity (in tons)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productController,
                decoration: const InputDecoration(labelText: 'Product'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _createOrder,
                  child: const Text('Create Order'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
