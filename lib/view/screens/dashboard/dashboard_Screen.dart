import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restotag_customer_app/view/screens/dashboard/orderSummary_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/restaurant_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/scanBarcode_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/setting_Screen.dart';

import '../../controller/DashboardController.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final DashboardController controller = Get.put(DashboardController());

  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const QRScannerScreen(),
    OrderSummaryPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    ));
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 0),
          _buildNavItem(Icons.favorite_border, 1),
          _buildNavItem(Icons.qr_code_scanner_outlined, 2),
          _buildNavItem(Icons.shopping_cart_outlined, 3),
          _buildNavItem(Icons.settings_outlined, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return IconButton(
        icon: Icon(icon, color: isSelected ? Colors.orange : Colors.grey),
        onPressed: () => controller.updateSelectedIndex(index),
      );
    });

  }
}

// =================== Home Screen ===================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.person_outline, color: Colors.white),
                Text(
                  "Choose Preference",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.orangeAccent,
                    decorationThickness: 2,
                  ),
                ),
                Icon(Icons.close, color: Colors.white),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  OrangeButton(
                    text: "BOOK RESTAURANT",
                    onPressed: () {
                      final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
                      if (dashboardState != null) {
                        dashboardState.setState(() {
                          dashboardState._pages[0] = const restaurantScreen(); // Replace HomeScreen with restaurantScreen
                          dashboardState._selectedIndex = 0; // Navigate to index 0
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  OrangeButton(
                    text: "BOOK HOTEL",
                    onPressed: () {
                      // Handle book hotel click
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Ensure space for bottom bar
          ],
        ),
      ),
    );
  }
}

class OrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const OrangeButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}

// =================== Restaurant List ===================
class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.person_outline, color: Colors.white),
                Text(
                  "Restaurants Main",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.search, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),
            // Filter buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {}, child: const Text("All")),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text("Veg", style: TextStyle(color: Colors.white)),
                ),
                TextButton(onPressed: () {}, child: const Text("Non-Veg")),
              ],
            ),
            const SizedBox(height: 20),
            // Restaurant Cards
            const RestaurantCard(),
            const RestaurantCard(),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              "https://images.unsplash.com/photo-1555992336-03a23c7b20e3",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: const Text("ABC Restaurant"),
            subtitle: const Text("XYZ, Area"),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.orange),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// =================== Placeholder Screens ===================
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Favorite Screen', style: TextStyle(fontSize: 24, color: Colors.white)),
    );
  }
}

