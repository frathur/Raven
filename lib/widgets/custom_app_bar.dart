import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget implementing Contemporary Spatial Minimalism design
/// Provides consistent navigation structure across the drone food delivery app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onSurface,
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: actions ?? _buildDefaultActions(context),
      iconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onSurface,
        size: 24,
      ),
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Show search icon on home screen
    if (currentRoute == '/home-screen') {
      return [
        IconButton(
          icon: const Icon(Icons.search, size: 24),
          onPressed: () => Navigator.pushNamed(context, '/search-screen'),
          tooltip: 'Search restaurants',
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, size: 24),
          onPressed: () =>
              Navigator.pushNamed(context, '/shopping-cart-screen'),
          tooltip: 'View cart',
        ),
      ];
    }

    // Show cart icon on restaurant detail screen
    if (currentRoute == '/restaurant-detail-screen') {
      return [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, size: 24),
          onPressed: () =>
              Navigator.pushNamed(context, '/shopping-cart-screen'),
          tooltip: 'View cart',
        ),
      ];
    }

    // Show tracking icon on checkout screen
    if (currentRoute == '/checkout-screen') {
      return [
        IconButton(
          icon: const Icon(Icons.location_on_outlined, size: 24),
          onPressed: () =>
              Navigator.pushNamed(context, '/live-tracking-screen'),
          tooltip: 'Track order',
        ),
      ];
    }

    return [];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
