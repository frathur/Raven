import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/hero_banner_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/restaurant_section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  String _currentLocation = "123 Main Street, Downtown";
  int _notificationCount = 3;
  Set<int> _favoriteRestaurants = {1, 5, 8};

  // Mock data for restaurants
  final List<Map<String, dynamic>> _recommendedRestaurants = [
    {
      "id": 1,
      "name": "Bella Italia",
      "cuisine": "Italian • Pizza",
      "rating": 4.8,
      "reviewCount": 250,
      "deliveryTime": 25,
      "deliveryFee": 0,
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
    {
      "id": 2,
      "name": "Dragon Palace",
      "cuisine": "Chinese • Asian",
      "rating": 4.6,
      "reviewCount": 180,
      "deliveryTime": 30,
      "deliveryFee": 2.99,
      "image":
          "https://images.unsplash.com/photo-1526318896980-cf78c088247c?auto=format&fit=crop&w=800&q=80",
    },
    {
      "id": 3,
      "name": "Taco Fiesta",
      "cuisine": "Mexican • Spicy",
      "rating": 4.7,
      "reviewCount": 320,
      "deliveryTime": 20,
      "deliveryFee": 0,
      "image":
          "https://images.pixabay.com/photo/2017/06/29/20/09/mexican-2456038_1280.jpg",
    },
    {
      "id": 4,
      "name": "Burger Junction",
      "cuisine": "American • Fast Food",
      "rating": 4.5,
      "reviewCount": 450,
      "deliveryTime": 15,
      "deliveryFee": 1.99,
      "image":
          "https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
  ];

  final List<Map<String, dynamic>> _popularRestaurants = [
    {
      "id": 5,
      "name": "Sushi Master",
      "cuisine": "Japanese • Sushi",
      "rating": 4.9,
      "reviewCount": 180,
      "deliveryTime": 35,
      "deliveryFee": 3.99,
      "image":
          "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?auto=format&fit=crop&w=800&q=80",
    },
    {
      "id": 6,
      "name": "Curry House",
      "cuisine": "Indian • Spicy",
      "rating": 4.6,
      "reviewCount": 290,
      "deliveryTime": 40,
      "deliveryFee": 2.49,
      "image":
          "https://images.pixabay.com/photo/2017/06/16/11/38/breakfast-2408818_1280.jpg",
    },
    {
      "id": 7,
      "name": "Mediterranean Grill",
      "cuisine": "Mediterranean • Healthy",
      "rating": 4.7,
      "reviewCount": 210,
      "deliveryTime": 28,
      "deliveryFee": 0,
      "image":
          "https://images.pexels.com/photos/1640772/pexels-photo-1640772.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
  ];

  final List<Map<String, dynamic>> _fastDeliveryRestaurants = [
    {
      "id": 8,
      "name": "Quick Bites",
      "cuisine": "Fast Food • Snacks",
      "rating": 4.4,
      "reviewCount": 380,
      "deliveryTime": 12,
      "deliveryFee": 0,
      "image":
          "https://images.unsplash.com/photo-1571091718767-18b5b1457add?auto=format&fit=crop&w=800&q=80",
    },
    {
      "id": 9,
      "name": "Coffee Corner",
      "cuisine": "Cafe • Beverages",
      "rating": 4.5,
      "reviewCount": 150,
      "deliveryTime": 10,
      "deliveryFee": 1.49,
      "image":
          "https://images.pixabay.com/photo/2017/05/26/12/39/coffee-2344157_1280.jpg",
    },
    {
      "id": 10,
      "name": "Sandwich Express",
      "cuisine": "Sandwiches • Quick",
      "rating": 4.3,
      "reviewCount": 220,
      "deliveryTime": 8,
      "deliveryFee": 0,
      "image":
          "https://images.pexels.com/photos/1633578/pexels-photo-1633578.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();

    // Simulate refresh API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _notificationCount = (_notificationCount + 1) % 10;
      });
    }
  }

  void _handleLocationTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.w),
            topRight: Radius.circular(6.w),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.neutralGray,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Select Delivery Location',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  _buildLocationOption(
                    icon: 'my_location',
                    title: 'Use Current Location',
                    subtitle: 'Enable GPS for accurate delivery',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentLocation = "Current Location";
                      });
                    },
                  ),
                  _buildLocationOption(
                    icon: 'home',
                    title: 'Home',
                    subtitle: '123 Main Street, Downtown',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentLocation = "123 Main Street, Downtown";
                      });
                    },
                  ),
                  _buildLocationOption(
                    icon: 'work',
                    title: 'Work',
                    subtitle: '456 Business Ave, Office District',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentLocation = "456 Business Ave, Office District";
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.neutralGray,
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accentYellow.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.accentYellow,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.textSecondary,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationTap() {
    Navigator.pushNamed(context, '/live-tracking-screen');
  }

  void _handleFavoriteToggle(int restaurantId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_favoriteRestaurants.contains(restaurantId)) {
        _favoriteRestaurants.remove(restaurantId);
      } else {
        _favoriteRestaurants.add(restaurantId);
      }
    });
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        // Skeleton for hero banner
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          height: 20.h,
          decoration: BoxDecoration(
            color: AppTheme.neutralGray,
            borderRadius: BorderRadius.circular(3.w),
          ),
        ),
        // Skeleton for quick actions
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: List.generate(
                4,
                (index) => Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppTheme.neutralGray,
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                    )),
          ),
        ),
        // Skeleton for restaurant sections
        ...List.generate(
            3,
            (sectionIndex) => Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: AppTheme.neutralGray,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                    SizedBox(
                      height: 28.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 4.w),
                        itemCount: 3,
                        itemBuilder: (context, index) => Container(
                          width: 70.w,
                          margin: EdgeInsets.only(right: 4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.neutralGray,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          LocationHeaderWidget(
            currentLocation: _currentLocation,
            notificationCount: _notificationCount,
            onLocationTap: _handleLocationTap,
            onNotificationTap: _handleNotificationTap,
          ),
          Expanded(
            child: _isLoading
                ? SingleChildScrollView(
                    child: _buildSkeletonLoader(),
                  )
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _handleRefresh,
                    color: AppTheme.accentYellow,
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeroBannerWidget(),
                          const QuickActionsWidget(),
                          SizedBox(height: 2.h),
                          RestaurantSectionWidget(
                            title: "Recommended for You",
                            subtitle: "Based on your preferences",
                            restaurants: _recommendedRestaurants,
                            favoriteRestaurants: _favoriteRestaurants,
                            onFavoriteToggle: _handleFavoriteToggle,
                          ),
                          SizedBox(height: 3.h),
                          RestaurantSectionWidget(
                            title: "Popular Restaurants",
                            subtitle: "Most ordered this week",
                            restaurants: _popularRestaurants,
                            favoriteRestaurants: _favoriteRestaurants,
                            onFavoriteToggle: _handleFavoriteToggle,
                          ),
                          SizedBox(height: 3.h),
                          RestaurantSectionWidget(
                            title: "Fast Delivery",
                            subtitle: "Get your food in under 15 minutes",
                            restaurants: _fastDeliveryRestaurants,
                            favoriteRestaurants: _favoriteRestaurants,
                            onFavoriteToggle: _handleFavoriteToggle,
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search-screen');
        },
        backgroundColor: AppTheme.accentYellow,
        foregroundColor: AppTheme.primaryBlack,
        child: CustomIconWidget(
          iconName: 'search',
          color: AppTheme.primaryBlack,
          size: 6.w,
        ),
      ),
    );
  }
}
