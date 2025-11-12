import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class TaskHeaderWidget extends StatelessWidget {
  final String title;
  final String category;
  final String urgency;
  final double rating;
  final bool isVerified;

  const TaskHeaderWidget({
    Key? key,
    required this.title,
    required this.category,
    required this.urgency,
    required this.rating,
    required this.isVerified,
  }) : super(key: key);

  Color _getUrgencyColor() {
    switch (urgency.toLowerCase()) {
      case 'urgent':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.5.h),

          // Category and Urgency Row
          Row(
            children: [
              // Category Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 2.w),

              // Urgency Indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: _getUrgencyColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getUrgencyColor().withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: _getUrgencyColor(),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      urgency,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getUrgencyColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Rating and Verification
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.warningLight,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    rating.toStringAsFixed(1),
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isVerified) ...[
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'verified',
                      color: AppTheme.successLight,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
