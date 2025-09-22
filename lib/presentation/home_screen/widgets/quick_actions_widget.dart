import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickActions = [
      {
        "icon": "search",
        "label": "Search Food",
        "color": AppTheme.accentYellow,
        "route": "/search-screen",
      },
      {
        "icon": "shopping_cart",
        "label": "My Cart",
        "color": AppTheme.successGreen,
        "route": "/shopping-cart-screen",
      },
      {
        "icon": "location_on",
        "label": "Track Order",
        "color": AppTheme.infoBlue,
        "route": "/live-tracking-screen",
      },
      {
        "icon": "favorite",
        "label": "Favorites",
        "color": AppTheme.errorRed,
        "route": "/search-screen",
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: quickActions.map((action) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, action["route"] as String);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                padding: EdgeInsets.symmetric(vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(3.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowSubtle,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color:
                            (action["color"] as Color).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: action["icon"] as String,
                        color: action["color"] as Color,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      action["label"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
