import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DroneInfoWidget extends StatelessWidget {
  final String droneId;
  final double altitude;
  final double speed;
  final double batteryLevel;
  final String pilotName;

  const DroneInfoWidget({
    super.key,
    required this.droneId,
    required this.altitude,
    required this.speed,
    required this.batteryLevel,
    required this.pilotName,
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
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentYellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'flight',
                  color: AppTheme.accentYellow,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drone $droneId',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Pilot: $pilotName',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Altitude',
                  '${altitude.toInt()} ft',
                  'terrain',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Speed',
                  '${speed.toInt()} mph',
                  'speed',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Battery',
                  '${batteryLevel.toInt()}%',
                  'battery_full',
                  color: _getBatteryColor(batteryLevel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    String iconName, {
    Color? color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color ?? AppTheme.textSecondary,
          size: 20,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getBatteryColor(double batteryLevel) {
    if (batteryLevel > 50) {
      return AppTheme.successGreen;
    } else if (batteryLevel > 20) {
      return AppTheme.warningOrange;
    } else {
      return AppTheme.errorRed;
    }
  }
}
