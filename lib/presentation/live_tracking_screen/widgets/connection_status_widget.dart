import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isOnline;
  final bool hasGpsSignal;
  final DateTime? lastUpdate;

  const ConnectionStatusWidget({
    super.key,
    required this.isOnline,
    required this.hasGpsSignal,
    this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isOnline && hasGpsSignal) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 10.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: _getStatusColor().withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowSubtle,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: _getStatusIcon(),
              color: AppTheme.surfaceWhite,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusTitle(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.surfaceWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _getStatusMessage(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.surfaceWhite.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (!isOnline) {
      return AppTheme.errorRed;
    } else if (!hasGpsSignal) {
      return AppTheme.warningOrange;
    }
    return AppTheme.successGreen;
  }

  String _getStatusIcon() {
    if (!isOnline) {
      return 'wifi_off';
    } else if (!hasGpsSignal) {
      return 'gps_off';
    }
    return 'check_circle';
  }

  String _getStatusTitle() {
    if (!isOnline) {
      return 'Connection Lost';
    } else if (!hasGpsSignal) {
      return 'GPS Signal Weak';
    }
    return 'Connected';
  }

  String _getStatusMessage() {
    if (!isOnline) {
      final lastUpdateText = lastUpdate != null
          ? 'Last update: ${_formatTime(lastUpdate!)}'
          : 'Showing cached data';
      return 'No internet connection. $lastUpdateText';
    } else if (!hasGpsSignal) {
      return 'Location accuracy may be reduced';
    }
    return 'Real-time tracking active';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}
