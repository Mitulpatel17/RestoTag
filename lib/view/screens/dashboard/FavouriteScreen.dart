import 'package:flutter/material.dart';
import 'package:restotag_customer_app/utils/customUI/FoodCategorySwitch.dart';
import 'dashboard_Screen.dart'; // for RestaurantCard

class Favouritescreen extends StatefulWidget {
  const Favouritescreen({super.key});

  @override
  State<Favouritescreen> createState() => _FavouritescreenState();
}

class _FavouritescreenState extends State<Favouritescreen> {
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
              "Favourite",
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
