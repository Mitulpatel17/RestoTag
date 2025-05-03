import 'package:flutter/material.dart';


class OrderSummaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrderSummaryPage();
  }
}

class OrderSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA), // Light gray background
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Order Summary'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Items
            buildOrderItem('Veg. Kabab', '01', '₹280'),
            buildOrderItem('Paneer Handi', '01', '₹450'),
            buildOrderItem('Butter Roti', '02', '₹120'),
            buildOrderItem('Mint Mojito', '01', '₹190'),
            SizedBox(height: 20),

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
            SizedBox(height: 20),

            // Subtotal and GST
            summaryRow('Sub-total', '₹1040'),
            summaryRow('GST', '₹187.2'),
            Divider(),
            summaryRow('Total', '₹1227.2', isBold: true),
            SizedBox(height: 20),

            // Pay Bill Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: Text(
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

  Widget buildOrderItem(String title, String quantity, String price) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(quantity, style: TextStyle(fontSize: 16)),
              SizedBox(width: 20),
              Text(price, style: TextStyle(fontSize: 16)),
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
