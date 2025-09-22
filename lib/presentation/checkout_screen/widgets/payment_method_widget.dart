import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final int selectedIndex;
  final Function(int) onMethodSelected;
  final VoidCallback onAddNewCard;

  const PaymentMethodWidget({
    super.key,
    required this.paymentMethods,
    required this.selectedIndex,
    required this.onMethodSelected,
    required this.onAddNewCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentMethods.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final method = paymentMethods[index];
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () => onMethodSelected(index),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentYellow.withValues(alpha: 0.1)
                        : AppTheme.neutralGray,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentYellow
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: _getPaymentIcon(
                                method['type'] as String? ?? ''),
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'] as String? ?? '',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (method['details'] != null) ...[
                              SizedBox(height: 0.5.h),
                              Text(
                                method['details'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.accentYellow,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: onAddNewCard,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.neutralGray,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.accentYellow,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Add New Payment Method',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentYellow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'credit_card':
        return 'credit_card';
      case 'apple_pay':
        return 'apple';
      case 'google_pay':
        return 'google';
      case 'paypal':
        return 'account_balance_wallet';
      default:
        return 'payment';
    }
  }
}
