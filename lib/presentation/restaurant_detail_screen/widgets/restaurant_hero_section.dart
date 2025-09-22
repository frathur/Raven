import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RestaurantHeroSection extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const RestaurantHeroSection({
    super.key,
    required this.restaurant,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      child: Stack(
        children: [
          // Hero image
          CustomImageWidget(
            imageUrl: restaurant["heroImage"] as String,
            width: double.infinity,
            height: 35.h,
            fit: BoxFit.cover,
          ),

          // Gradient overlay
          Container(
            height: 35.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppTheme.primaryBlack.withValues(alpha: 0.3),
                  AppTheme.primaryBlack.withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Restaurant logo overlay
          Positioned(
            bottom: 4.h,
            left: 4.w,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowSubtle,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: restaurant["logo"] as String,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Favorite button
          Positioned(
            top: 6.h,
            right: 4.w,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowSubtle,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isFavorite ? 'favorite' : 'favorite_border',
                    color:
                        isFavorite ? AppTheme.errorRed : AppTheme.textSecondary,
                    size: 6.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
