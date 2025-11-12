import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskCardWidget extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isHelper;
  final VoidCallback onTap;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final VoidCallback? onEdit;

  const TaskCardWidget({
    Key? key,
    required this.task,
    required this.isHelper,
    required this.onTap,
    this.onSave,
    this.onShare,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = task['title'] ?? 'Untitled Task';
    final String category = task['category'] ?? 'General';
    final double distance = (task['distance'] ?? 0.0).toDouble();
    final double payment = (task['payment'] ?? 0.0).toDouble();
    final String urgency = task['urgency'] ?? 'normal';
    final String status = task['status'] ?? 'open';
    final String description = task['description'] ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Category Icon
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getCategoryIcon(category),
                      color: _getCategoryColor(category),
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Title and Category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        category,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Urgency Indicator
                if (urgency == 'urgent')
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'URGENT',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 2.h),

            // Description
            if (description.isNotEmpty)
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            if (description.isNotEmpty) SizedBox(height: 2.h),

            // Footer Row
            Row(
              children: [
                // Distance
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${distance.toStringAsFixed(1)} km',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(width: 4.w),

                // Status (for posters)
                if (!isHelper) ...[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                const Spacer(),

                // Payment Amount
                Text(
                  '\$${payment.toStringAsFixed(0)}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            // Action Buttons (for helpers)
            if (isHelper && status == 'open') ...[
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSave,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'bookmark_border',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text('Save'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                      ),
                      child: Text('Apply Now'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cleaning':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'delivery':
        return AppTheme.lightTheme.primaryColor;
      case 'handyman':
        return const Color(0xFFD97706);
      case 'shopping':
        return const Color(0xFF7C3AED);
      case 'pet care':
        return const Color(0xFFDC2626);
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cleaning':
        return 'cleaning_services';
      case 'delivery':
        return 'local_shipping';
      case 'handyman':
        return 'build';
      case 'shopping':
        return 'shopping_cart';
      case 'pet care':
        return 'pets';
      default:
        return 'work';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'in_progress':
        return const Color(0xFFD97706);
      case 'completed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'cancelled':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }
}
