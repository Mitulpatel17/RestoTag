import 'package:flutter/material.dart';
import 'package:restotag_customer_app/utils/AppColors.dart';

class OrderItem {
  final String name;
  final double price;
  int quantity;

  OrderItem({required this.name, required this.price, this.quantity = 1});
}

class OrderSummaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrderSummaryPage();
  }
}

class OrderSummaryPage extends StatefulWidget {
  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  List<OrderItem> orderItems = [
    OrderItem(name: 'Veg. Kabab', price: 280),
    OrderItem(name: 'Paneer Handi', price: 450),
    OrderItem(name: 'Butter Roti', price: 60, quantity: 2),
    OrderItem(name: 'Mint Mojito', price: 190),
  ];

  void updateQuantity(int index, int change) {
    setState(() {
      final newQuantity = orderItems[index].quantity + change;
      if (newQuantity >= 0) {
        orderItems[index].quantity = newQuantity;
      }
    });
  }

  double get subtotal =>
      orderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get gst => subtotal * 0.18;

  double get total => subtotal + gst;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // backgroundColor: const Color(0xFFF5F7FA),
      // appBar: AppBar(
      //   // backgroundColor: AppColors.primary,
      //   title: const Text('Order Summary'),
      //   centerTitle: true,
      //   // actions: [
      //   //   IconButton(
      //   //     icon: const Icon(Icons.search),
      //   //     onPressed: () {},
      //   //   ),
      //   // ],
      // ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Items List
            Center(
              child: Text(
                "Favourite",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...orderItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return buildOrderItem(item, index);
            }).toList(),

            const SizedBox(height: 20),

            // Coupon Code Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Coupon Code',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Subtotal and GST
            summaryRow('Sub-total', '₹${subtotal.toStringAsFixed(2)}'),
            summaryRow('GST', '₹${gst.toStringAsFixed(2)}'),
            const Divider(),
            summaryRow('Total', '₹${total.toStringAsFixed(2)}', isBold: true),

            const SizedBox(height: 20),

            // Pay Bill Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Add payment action here
                },
                child: const Text(
                  'PAY BILL',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderItem(OrderItem item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.name, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
                onPressed: () => updateQuantity(index, -1),
              ),
              Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20, color: Colors.grey),
                onPressed: () => updateQuantity(index, 1),
              ),
              const SizedBox(width: 10),
              Text('₹${(item.price * item.quantity).toStringAsFixed(0)}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget summaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
