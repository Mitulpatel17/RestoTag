import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Card",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close, color: Color(0xFF9CA3AF), size: 20,),
                    onPressed: () { Get.back();},
                    splashRadius: 20,)
                ],
              ),
              const SizedBox(height: 40),
              _buildTextField(
                hintText: 'Cardholder Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Card Number',
                icon: Icons.credit_card,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Expiry Date',
                icon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Security Code',
                icon: Icons.security,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blueGrey),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.blueGrey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
