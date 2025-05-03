import 'package:flutter/material.dart';
import 'package:restotag_customer_app/view/screens/dashboard/orderSummary_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/scanBarcode_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/setting_Screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool isBookingRestaurant = false;

  final List<Widget> _pages = [
    Placeholder(), // Home will be replaced manually
    FavoriteScreen(),
    QRScannerScreen(),
    OrderSummaryApp(),
    SettingsApp(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      isBookingRestaurant = false; // Reset when switching tabs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Special case for Home
          isBookingRestaurant ? RestaurantListScreen() : HomeScreen(onBookRestaurant: () {
            setState(() {
              isBookingRestaurant = true;
            });
          }),
          ..._pages.sublist(1), // For other tabs
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.orange : Colors.grey,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}

// =================== Home Screen (Choose Preference) ===================
class HomeScreen extends StatelessWidget {
  final VoidCallback onBookRestaurant;

  const HomeScreen({required this.onBookRestaurant});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.person_outline, color: Colors.grey),
                Text(
                  "Choose Preference",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.close, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  OrangeButton(
                    text: "BOOK RESTAURANT",
                    onPressed: () {
                      onBookRestaurant();
                    },
                  ),
                  const SizedBox(height: 20),
                  OrangeButton(
                    text: "BOOK HOTEL",
                    onPressed: () {
                      // Handle book hotel click if needed
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const OrangeButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// =================== Restaurant List Screen (After Book Restaurant click) ===================
class RestaurantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.person_outline, color: Colors.grey),
              Text(
                "Restaurants",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.search, color: Colors.grey),
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
          RestaurantCard(),
          RestaurantCard(),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
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

// =================== Other Placeholder Screens ===================
class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Favorite Screen', style: TextStyle(fontSize: 24)),
    );
  }
}


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Cart Screen', style: TextStyle(fontSize: 24)),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Screen', style: TextStyle(fontSize: 24)),
    );
  }
}
