import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restotag_customer_app/view/screens/dashboard/orderSummary_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/scanBarcode_Screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/setting_Screen.dart';

import '../screens/dashboard/dashboard_Screen.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;

  var pages = <Widget>[
    const HomeScreen(),
    const FavoriteScreen(),
    const QRScannerScreen(),
    OrderSummaryPage(),
    const SettingsPage(),
  ].obs;

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void replacePage(int index, Widget newPage) {
    pages[index] = newPage;
  }
}
