import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LocationHeaderWidget extends StatelessWidget {
  final String currentLocation;
  final int notificationCount;
  final VoidCallback? onLocationTap;
  final VoidCallback? onNotificationTap;

  const LocationHeaderWidget({
    Key? key,
    required this.currentLocation,
    required this.notificationCount,
    this.onLocationTap,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onLocationTap,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    currentLocation,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).primaryColor,
                  size: 24.sp,
                ),
              ],
            ),
          ),
          Spacer(),
          if (notificationCount > 0)
            GestureDetector(
              onTap: onNotificationTap,
              child: Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Theme.of(context).primaryColor,
                    size: 24.sp,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
