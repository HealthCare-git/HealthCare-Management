

import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? mobileLarge;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.mobileLarge,
  }) : super(key: key);



  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 515;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1100;
  }

  static bool isMobileLarge(BuildContext context) =>
      MediaQuery.of(context).size.width <= 800;

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <= 1100;
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size _size = MediaQuery.of(context).size;
        if (_size.width >= 1024) {
          return desktop;
        } else if (_size.width >= 800 && tablet != null) {
          return tablet!;
        } else if (_size.width >= 450 && mobileLarge != null) {
          return mobileLarge!;
        } else {
          return mobile;
        }
      },
    );
  }
}