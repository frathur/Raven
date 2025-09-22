import 'package:flutter/material.dart';
import '../presentation/live_tracking_screen/live_tracking_screen.dart';
import '../presentation/shopping_cart_screen/shopping_cart_screen.dart';
import '../presentation/search_screen/search_screen.dart';
import '../presentation/checkout_screen/checkout_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/restaurant_detail_screen/restaurant_detail_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String liveTracking = '/live-tracking-screen';
  static const String shoppingCart = '/shopping-cart-screen';
  static const String search = '/search-screen';
  static const String checkout = '/checkout-screen';
  static const String home = '/home-screen';
  static const String restaurantDetail = '/restaurant-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LiveTrackingScreen(),
    liveTracking: (context) => const LiveTrackingScreen(),
    shoppingCart: (context) => const ShoppingCartScreen(),
    search: (context) => const SearchScreen(),
    checkout: (context) => const CheckoutScreen(),
    home: (context) => const HomeScreen(),
    restaurantDetail: (context) => const RestaurantDetailScreen(),
    // TODO: Add your other routes here
  };
}
