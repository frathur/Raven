import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeliveryStatusWidget extends StatelessWidget {
  final String currentStatus;
  final DateTime estimatedArrival;
  final String orderId;

  const DeliveryStatusWidget({
    super.key,
    required this.currentStatus,
    required this.estimatedArrival,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #$orderId',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(currentStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentStatus,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _getStatusColor(currentStatus),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildStatusProgress(),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.textSecondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Estimated arrival: ${_formatTime(estimatedArrival)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusProgress() {
    final statuses = [
      'Order Confirmed',
      'Preparing',
      'Drone Dispatched',
      'In Transit',
      'Approaching',
      'Delivered'
    ];

    final currentIndex = statuses.indexOf(currentStatus);

    return Column(
      children: [
        Row(
          children: statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final isActive = index <= currentIndex;
            final isLast = index == statuses.length - 1;

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.accentYellow
                          : AppTheme.neutralGray,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isActive
                            ? AppTheme.accentYellow
                            : AppTheme.neutralGray,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: statuses.map((status) {
            final index = statuses.indexOf(status);
            final isActive = index <= currentIndex;

            return Expanded(
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color:
                      isActive ? AppTheme.primaryBlack : AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Confirmed':
      case 'Preparing':
        return AppTheme.infoBlue;
      case 'Drone Dispatched':
      case 'In Transit':
        return AppTheme.warningOrange;
      case 'Approaching':
        return AppTheme.accentYellow;
      case 'Delivered':
        return AppTheme.successGreen;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }
}
