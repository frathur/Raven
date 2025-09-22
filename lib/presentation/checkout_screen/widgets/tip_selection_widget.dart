import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TipSelectionWidget extends StatelessWidget {
  final double selectedTipPercentage;
  final double customTipAmount;
  final double subtotal;
  final Function(double) onTipPercentageChanged;
  final Function(double) onCustomTipChanged;
  final TextEditingController customTipController;

  const TipSelectionWidget({
    super.key,
    required this.selectedTipPercentage,
    required this.customTipAmount,
    required this.subtotal,
    required this.onTipPercentageChanged,
    required this.onCustomTipChanged,
    required this.customTipController,
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
            'Add Tip',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Support your delivery partner',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          // Tip percentage buttons
          Row(
            children: [
              Expanded(
                child: _buildTipButton(15.0, context),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildTipButton(18.0, context),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildTipButton(20.0, context),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Custom tip input
          Row(
            children: [
              Text(
                'Custom: \$',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: TextField(
                  controller: customTipController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.accentYellow,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0.0;
                    onCustomTipChanged(amount);
                  },
                ),
              ),
            ],
          ),
          if (selectedTipPercentage > 0 || customTipAmount > 0) ...[
            SizedBox(height: 1.h),
            Text(
              'Tip amount: \$${_calculateTipAmount().toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.accentYellow,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipButton(double percentage, BuildContext context) {
    final isSelected = selectedTipPercentage == percentage;
    final tipAmount = subtotal * (percentage / 100);

    return GestureDetector(
      onTap: () => onTipPercentageChanged(percentage),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentYellow : AppTheme.neutralGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentYellow
                : AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              '${percentage.toInt()}%',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppTheme.primaryBlack
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              '\$${tipAmount.toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color:
                    isSelected ? AppTheme.primaryBlack : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTipAmount() {
    if (customTipAmount > 0) {
      return customTipAmount;
    }
    return subtotal * (selectedTipPercentage / 100);
  }
}
