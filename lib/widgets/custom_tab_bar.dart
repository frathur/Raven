import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom tab bar widget for restaurant categories and menu sections
/// Implements gesture-aware scrolling with visual feedback
class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int)? onTap;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTap,
    this.isScrollable = true,
    this.padding,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        isScrollable: isScrollable,
        indicatorColor:
            indicatorColor ?? const Color(0xFFFFD700), // Accent yellow
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        labelColor: labelColor ?? colorScheme.onSurface,
        unselectedLabelColor: unselectedLabelColor ?? const Color(0xFF666666),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
      ),
    );
  }

  /// Factory constructor for restaurant menu categories
  factory CustomTabBar.menuCategories({
    required int selectedIndex,
    Function(int)? onTap,
  }) {
    return CustomTabBar(
      tabs: const [
        'Popular',
        'Appetizers',
        'Mains',
        'Desserts',
        'Beverages',
      ],
      selectedIndex: selectedIndex,
      onTap: onTap,
      isScrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Factory constructor for cuisine filter tabs
  factory CustomTabBar.cuisineFilter({
    required int selectedIndex,
    Function(int)? onTap,
  }) {
    return CustomTabBar(
      tabs: const [
        'All',
        'Italian',
        'Asian',
        'Mexican',
        'American',
        'Indian',
        'Mediterranean',
      ],
      selectedIndex: selectedIndex,
      onTap: onTap,
      isScrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// Factory constructor for delivery status tracking
  factory CustomTabBar.deliveryStatus({
    required int selectedIndex,
    Function(int)? onTap,
  }) {
    return CustomTabBar(
      tabs: const [
        'Preparing',
        'Ready',
        'In Transit',
        'Delivered',
      ],
      selectedIndex: selectedIndex,
      onTap: onTap,
      isScrollable: false,
      padding: const EdgeInsets.all(16),
    );
  }
}
