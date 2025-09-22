import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double taxes;
  final double total;
  final String? promoCode;
  final double? discount;
  final VoidCallback? onPromoApplied;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.taxes,
    required this.total,
    this.promoCode,
    this.discount,
    this.onPromoApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowSubtle,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          SizedBox(height: 1.h),
          _buildSummaryRow(
              'Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
          SizedBox(height: 1.h),
          _buildSummaryRow('Taxes & Fees', '\$${taxes.toStringAsFixed(2)}'),
          if (discount != null && discount! > 0) ...[
            SizedBox(height: 1.h),
            _buildSummaryRow(
              'Discount${promoCode != null ? ' ($promoCode)' : ''}',
              '-\$${discount!.toStringAsFixed(2)}',
              isDiscount: true,
            ),
          ],
          SizedBox(height: 2.h),
          Container(
            height: 1,
            color: AppTheme.neutralGray,
          ),
          SizedBox(height: 2.h),
          _buildSummaryRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount,
      {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                )
              : AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        Text(
          amount,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentYellow,
                )
              : isDiscount
                  ? AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.w600,
                    )
                  : AppTheme.lightTheme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
