import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    
    double maxWidth;
    if (isMobile) {
      maxWidth = double.infinity; // Full width on mobile
    } else if (isTablet) {
      maxWidth = 800; // Limit tablet to 800px
    } else {
      maxWidth = 1200; // Limit desktop to 1200px
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}