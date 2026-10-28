import 'package:flutter/material.dart';

/// A realistic checkout screen for a coffee order.
///
/// Every SizedBox on this screen is labelled with a comment
/// (SizedBox #1, #2, ...) so it is easy to point at during the presentation.
/// SizedBox does three everyday jobs here:
///   1. Give a widget a FIXED SIZE (product image, quantity label).
///   2. Add EMPTY SPACE between widgets (no child, just width or height).
///   3. Make a button FULL WIDTH (width: double.infinity).
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const double _unitPrice = 4.50;
  static const double _deliveryFee = 1.99;

  int _quantity = 1;

  double get _subtotal => _unitPrice * _quantity;
  double get _total => _subtotal + _deliveryFee;

  void _changeQuantity(int delta) {
    setState(() => _quantity = (_quantity + delta).clamp(1, 99));
  }

  void _placeOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order placed: $_quantity × Caramel Latte '
          '(\$${_total.toStringAsFixed(2)})',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProductRow(textTheme),

          // SizedBox #3 — vertical spacer: no child, only a height.
          const SizedBox(height: 24),

          Text('Order summary', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildPriceRow('Subtotal', _subtotal),
          const SizedBox(height: 8),
          _buildPriceRow('Delivery', _deliveryFee),
          const Divider(height: 32),
          _buildPriceRow('Total', _total, isBold: true),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // SizedBox #5 — full-width button.
          // width: double.infinity stretches the button to the screen edges;
          // height: 52 gives it a fixed, easy-to-tap height.
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _placeOrder,
              child: Text('Pay \$${_total.toStringAsFixed(2)}'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductRow(TextTheme textTheme) {
    return Row(
      children: [
        // SizedBox #1 — fixed-size product image.
        // Without it the image would size itself; with it the image is
        // always exactly 120 × 120, so the layout never jumps around.
        SizedBox(
          width: 120,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const ColoredBox(
              color: Color(0xFF8D6E63),
              child: Icon(Icons.coffee, size: 56, color: Colors.white),
            ),
          ),
        ),

        // SizedBox #2 — horizontal spacer between image and text.
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Caramel Latte', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('Medium · Oat milk', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(
                '\$${_unitPrice.toStringAsFixed(2)}',
                style: textTheme.titleMedium,
              ),
              _buildQuantityPicker(textTheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityPicker(TextTheme textTheme) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _changeQuantity(-1),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        // SizedBox #4 — fixed-width label.
        // Keeps the + button from shifting when the number goes from 9 to 10.
        SizedBox(
          width: 32,
          child: Text(
            '$_quantity',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium,
          ),
        ),
        IconButton(
          onPressed: () => _changeQuantity(1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    final style = isBold
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('\$${amount.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}
