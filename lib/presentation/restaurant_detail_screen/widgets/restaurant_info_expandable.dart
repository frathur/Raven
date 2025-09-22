import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RestaurantInfoExpandable extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantInfoExpandable({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantInfoExpandable> createState() =>
      _RestaurantInfoExpandableState();
}

class _RestaurantInfoExpandableState extends State<RestaurantInfoExpandable> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
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
          // Header
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.infoBlue,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Restaurant Information',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  const Spacer(),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.textSecondary,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hours
                  _buildInfoRow(
                    'access_time',
                    'Hours',
                    widget.restaurant["hours"] as String,
                  ),

                  SizedBox(height: 2.h),

                  // Contact
                  _buildInfoRow(
                    'phone',
                    'Contact',
                    widget.restaurant["phone"] as String,
                  ),

                  SizedBox(height: 2.h),

                  // Address
                  _buildInfoRow(
                    'location_on',
                    'Address',
                    widget.restaurant["address"] as String,
                  ),

                  SizedBox(height: 3.h),

                  // Reviews section
                  Row(
                    children: [
                      Text(
                        'Customer Reviews',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'View All',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.infoBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Sample reviews
                  ..._buildReviewsList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String iconName, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.textSecondary,
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildReviewsList() {
    final reviews = [
      {
        "name": "Sarah Johnson",
        "rating": 5,
        "comment":
            "Amazing food quality and fast delivery! The pasta was perfectly cooked.",
        "date": "2 days ago"
      },
      {
        "name": "Mike Chen",
        "rating": 4,
        "comment":
            "Great restaurant with authentic flavors. Delivery was on time.",
        "date": "1 week ago"
      },
      {
        "name": "Emma Wilson",
        "rating": 5,
        "comment":
            "Best Italian food in the city! Highly recommend the margherita pizza.",
        "date": "2 weeks ago"
      },
    ];

    return reviews.take(2).map((review) {
      return Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.neutralGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  review["name"] as String,
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                const Spacer(),
                Row(
                  children: List.generate(5, (index) {
                    return CustomIconWidget(
                      iconName: index < (review["rating"] as int)
                          ? 'star'
                          : 'star_border',
                      color: AppTheme.accentYellow,
                      size: 3.w,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              review["comment"] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              review["date"] as String,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
