import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom bottom navigation bar implementing gesture-aware navigation
/// Optimized for one-handed usage with contextual visibility
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool visible;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _handleNavigation(context, index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFFFFD700), // Accent yellow
            unselectedItemColor: const Color(0xFF666666), // Text secondary
            selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24),
                activeIcon: Icon(Icons.home, size: 24),
                label: 'Home',
                tooltip: 'Browse restaurants',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined, size: 24),
                activeIcon: Icon(Icons.search, size: 24),
                label: 'Search',
                tooltip: 'Search food',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 24),
                activeIcon: Icon(Icons.shopping_cart, size: 24),
                label: 'Cart',
                tooltip: 'View cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined, size: 24),
                activeIcon: Icon(Icons.location_on, size: 24),
                label: 'Track',
                tooltip: 'Track delivery',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Default navigation behavior
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-screen',
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushNamed(context, '/search-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/shopping-cart-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/live-tracking-screen');
        break;
    }
  }

  /// Factory constructor for contextual visibility
  /// Hides bottom bar during cart building and checkout flows
  factory CustomBottomBar.contextual({
    required BuildContext context,
    required int currentIndex,
    Function(int)? onTap,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final shouldHide = currentRoute == '/checkout-screen' ||
        currentRoute == '/restaurant-detail-screen';

    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      visible: !shouldHide,
    );
  }
}
