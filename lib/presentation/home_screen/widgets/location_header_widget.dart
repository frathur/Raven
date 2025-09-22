import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LocationHeaderWidget extends StatelessWidget {
  final String location;
  final VoidCallback? onTap;

  const LocationHeaderWidget({
    Key? key,
    required this.location,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
              location,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
                size: 24.sp,
              ),
            ),
        ],
      ),
    );
  }
}
