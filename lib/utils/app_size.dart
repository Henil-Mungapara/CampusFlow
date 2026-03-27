import 'package:flutter/material.dart';

class AppSize {
  static late double width;
  static late double height;

  static void init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  static double get wp => width / 100;
  static double get hp => height / 100;
}
