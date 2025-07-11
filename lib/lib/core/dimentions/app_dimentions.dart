import 'package:flutter/material.dart';

class AppDimensions {
  static double leftRightPadding=16.0;
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double topPadding(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double bottomPadding(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  static double widthPercentage(BuildContext context, double percent) =>
      screenWidth(context) * percent;

  static double heightPercentage(BuildContext context, double percent) =>
      screenHeight(context) * percent;
}
