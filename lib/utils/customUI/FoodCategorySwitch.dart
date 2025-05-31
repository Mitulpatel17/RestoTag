import 'package:flutter/material.dart';
import 'package:restotag_customer_app/utils/AppColors.dart';




class FoodCategorySwitch extends StatefulWidget {
  final Function(String) onCategoryChanged;

  const FoodCategorySwitch({required this.onCategoryChanged, Key? key})
      : super(key: key);

  @override
  State<FoodCategorySwitch> createState() => _FoodCategorySwitchState();
}

class _FoodCategorySwitchState extends State<FoodCategorySwitch> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['All', 'Veg', 'Non-Veg'].map((category) {
        bool isSelected = category == selectedCategory;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
              widget.onCategoryChanged(selectedCategory);
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

