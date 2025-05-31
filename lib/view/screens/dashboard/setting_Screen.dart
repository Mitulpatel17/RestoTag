import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restotag_customer_app/view/screens/dashboard/addcard_Screen.dart';

import '../../controller/DashboardController.dart';
import 'aboutus_screen.dart';


class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});

  @override Widget build(BuildContext context) {
    return SettingsPage();
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color orangeColor = Color(0xFFF59E0B);
  static const Color lightGrayBackground = Color(0xFFF0F6FA);
  static const Color grayText = Color(0xFF9CA3AF);

  void onNameTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name clicked')),);
  }

  void onMailTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mail clicked')),);
  }

  void onMobileNoTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mobile No. clicked')),);
  }

  void onSavedCardTap(BuildContext context) {
    final controller = Get.find<DashboardController>();
    controller.replacePage(4, const AddCardScreen());
    controller.updateSelectedIndex(4); // Navigate to it
  }

  void onAboutUsTap(BuildContext context) {
    Get.to(AboutUsScreen());
  }

  Widget buildSettingButton(BuildContext context, IconData icon, String label,
      VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: lightGrayBackground, borderRadius: BorderRadius.circular(8),),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          foregroundColor: grayText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(
              8),),),
        onPressed: onTap,
        child: Row(children: [
          Icon(icon, color: grayText, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(
            fontSize: 14, color: grayText, fontWeight: FontWeight.w400,),),
        ],),),);
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, body: SafeArea(child: Padding(
      padding: const EdgeInsets.only(top: 64, left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Center(child: Text('Settings', style: TextStyle(
              color: orangeColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,),),),
            Positioned(
              right: 0, child: IconButton(
              icon: const Icon(
                Icons.close, color: Color(0xFF9CA3AF), size: 20,),
              onPressed: () { Get.back();},
              splashRadius: 20,),),
          ],),
        const SizedBox(height: 32),
        buildSettingButton(
            context, Icons.person_outline, 'Name', () => onNameTap(context)),
        buildSettingButton(
            context, Icons.mail_outline, 'Mail', () => onMailTap(context)),
        buildSettingButton(context, Icons.phone_outlined, 'Mobile No.', () =>
            onMobileNoTap(context)),
        buildSettingButton(
            context, Icons.credit_card_outlined, 'Saved Card', () =>
            onSavedCardTap(context)),
        buildSettingButton(context, Icons.info_outline, 'About Us', () =>
            onAboutUsTap(context)),
      ],),),),);
  }
}