import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './restaurant_card_widget.dart';

class RestaurantSectionWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Map<String, dynamic>> restaurants;
  final Set<int> favoriteRestaurants;
  final Function(int)? onFavoriteToggle;

  const RestaurantSectionWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.restaurants,
    required this.favoriteRestaurants,
    this.onFavoriteToggle,
  });

  @override
  State<RestaurantSectionWidget> createState() =>
      _RestaurantSectionWidgetState();
}

class _RestaurantSectionWidgetState extends State<RestaurantSectionWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        widget.subtitle!,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/search-screen');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.neutralGray,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.primaryBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward_ios',
                        color: AppTheme.primaryBlack,
                        size: 3.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 28.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 4.w),
            itemCount: widget.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = widget.restaurants[index];
              final restaurantId = restaurant["id"] as int;
              final isFavorite =
                  widget.favoriteRestaurants.contains(restaurantId);

              return RestaurantCardWidget(
                restaurant: restaurant,
                isFavorite: isFavorite,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/restaurant-detail-screen',
                    arguments: restaurant,
                  );
                },
                onFavoriteToggle: () {
                  widget.onFavoriteToggle?.call(restaurantId);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
