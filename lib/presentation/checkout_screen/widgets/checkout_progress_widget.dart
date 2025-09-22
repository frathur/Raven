import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CheckoutProgressWidget extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CheckoutProgressWidget({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index <= currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.successGreen
                              : isActive
                                  ? AppTheme.accentYellow
                                  : AppTheme.neutralGray,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive
                                ? AppTheme.accentYellow
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.surfaceWhite,
                                  size: 16,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? AppTheme.primaryBlack
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        steps[index],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight:
                              isActive ? FontWeight.w500 : FontWeight.w400,
                          color: isActive
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 8.w,
                    height: 2,
                    color: isCompleted
                        ? AppTheme.successGreen
                        : AppTheme.neutralGray,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
