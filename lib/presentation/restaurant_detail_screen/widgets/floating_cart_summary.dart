import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FloatingCartSummary extends StatelessWidget {
  final int itemCount;
  final String totalAmount;
  final VoidCallback onTap;

  const FloatingCartSummary({
    super.key,
    required this.itemCount,
    required this.totalAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    return Positioned(
      bottom: 2.h,
      left: 4.w,
      right: 4.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlack,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowSubtle,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Cart icon with item count
              Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: AppTheme.surfaceWhite,
                    size: 6.w,
                  ),
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.accentYellow,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 4.w,
                        minHeight: 4.w,
                      ),
                      child: Text(
                        itemCount.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 8.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 3.w),

              // Item count text
              Text(
                '$itemCount item${itemCount > 1 ? 's' : ''} added',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.surfaceWhite,
                ),
              ),

              const Spacer(),

              // Total amount
              Text(
                totalAmount,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.accentYellow,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(width: 2.w),

              // Arrow icon
              CustomIconWidget(
                iconName: 'arrow_forward',
                color: AppTheme.surfaceWhite,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
