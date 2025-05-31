import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restotag_customer_app/view/screens/dashboard/orderSummary_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/restaurant_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/scanBarcode_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/setting_Screen.dart';

import '../../../utils/customUI/FoodCategorySwitch.dart';
import 'FavouriteScreen.dart';

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
    Placeholder(), // Home will be replaced manually
    Favouritescreen(),
    QRScannerScreen(),
    OrderSummaryApp(),
    SettingsApp(),
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
            Center(
              child: Text(
                "Choose Preference",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

// =================== Restaurant List Screen (After Book Restaurant click) ===================
class RestaurantListScreen extends StatefulWidget {
  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  String selectedCategory = 'All';

  final List<Map<String, String>> allRestaurants = [
    {
      'name': 'ABC Restaurant',
      'area': 'XYZ, Area',
      'type': 'Veg',
      'image': 'https://images.unsplash.com/photo-1555992336-03a23c7b20e3',
    },
    {
      'name': 'Non-Veg Palace',
      'area': '123, Area',
      'type': 'Non-Veg',
      'image': 'https://images.unsplash.com/photo-1606756791461-d1003b37f245',
    },
    {
      'name': 'Mixed Delight',
      'area': '456, Area',
      'type': 'All',
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedCategory == 'All'
        ? allRestaurants
        : allRestaurants
        .where((restaurant) => restaurant['type'] == selectedCategory)
        .toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Text(
              "Restaurants",
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: FoodCategorySwitch(
              onCategoryChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20),

          if (filteredList.isEmpty)
            Center(
              child: Text(
                'No $selectedCategory restaurants found.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...filteredList.map((restaurant) {
              return RestaurantCard(
                name: restaurant['name']!,
                area: restaurant['area']!,
                imageUrl: restaurant['image']!,
              );
            }).toList(),
        ],
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

