import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
                    "About Us",
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
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  'assets/logo.png', // Replace with your asset image
                  height: 100,
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoCard(
                icon: Icons.location_on_outlined,
                text: 'Floor 1,\nABC Area,\nXYZ City,\nState-0001',
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                icon: Icons.phone_outlined,
                text: '9812312345',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
