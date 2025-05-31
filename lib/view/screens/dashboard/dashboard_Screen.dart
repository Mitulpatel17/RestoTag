import 'package:flutter/material.dart';
import 'package:restotag_customer_app/view/screens/dashboard/orderSummary_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/scanBarcode_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/setting_Screen.dart';

import '../../../utils/customUI/FoodCategorySwitch.dart';
import 'FavouriteScreen.dart';


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
    Favouritescreen(),
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
  final String name;
  final String area;
  final String imageUrl;

  const RestaurantCard({
    required this.name,
    required this.area,
    required this.imageUrl,
  });

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
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: Text(name),
            subtitle: Text(area),
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
