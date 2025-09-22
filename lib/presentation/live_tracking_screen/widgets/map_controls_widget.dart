import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapControlsWidget extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCenterOnDrone;
  final VoidCallback onToggleMapType;
  final VoidCallback onEmergencyContact;
  final bool isSatelliteView;

  const MapControlsWidget({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenterOnDrone,
    required this.onToggleMapType,
    required this.onEmergencyContact,
    required this.isSatelliteView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      right: 4.w,
      top: 15.h,
      child: Column(
        children: [
          // Zoom controls
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
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
              children: [
                _buildControlButton(
                  context,
                  'add',
                  onZoomIn,
                  'Zoom in',
                ),
                Container(
                  height: 1,
                  color: AppTheme.neutralGray,
                ),
                _buildControlButton(
                  context,
                  'remove',
                  onZoomOut,
                  'Zoom out',
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          // Center on drone
          Container(
            decoration: BoxDecoration(
              color: AppTheme.accentYellow,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowSubtle,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildControlButton(
              context,
              'my_location',
              onCenterOnDrone,
              'Center on drone',
              backgroundColor: AppTheme.accentYellow,
              iconColor: AppTheme.primaryBlack,
            ),
          ),
          SizedBox(height: 2.h),
          // Map type toggle
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowSubtle,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildControlButton(
              context,
              isSatelliteView ? 'map' : 'satellite',
              onToggleMapType,
              isSatelliteView ? 'Map view' : 'Satellite view',
            ),
          ),
          SizedBox(height: 2.h),
          // Emergency contact
          Container(
            decoration: BoxDecoration(
              color: AppTheme.errorRed,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowSubtle,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildControlButton(
              context,
              'emergency',
              onEmergencyContact,
              'Emergency contact',
              backgroundColor: AppTheme.errorRed,
              iconColor: AppTheme.surfaceWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context,
    String iconName,
    VoidCallback onPressed,
    String tooltip, {
    Color? backgroundColor,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: backgroundColor ?? colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 12.w,
          height: 12.w,
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: iconColor ?? colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
