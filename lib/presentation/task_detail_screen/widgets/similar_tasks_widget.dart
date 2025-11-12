import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SimilarTasksWidget extends StatelessWidget {
  final List<Map<String, dynamic>> similarTasks;
  final Function(Map<String, dynamic>)? onTaskTap;

  const SimilarTasksWidget({
    Key? key,
    required this.similarTasks,
    this.onTaskTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (similarTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'recommend',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Similar Tasks',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: similarTasks.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final task = similarTasks[index];
                return _buildSimilarTaskCard(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarTaskCard(Map<String, dynamic> task) {
    return GestureDetector(
      onTap: () => onTaskTap?.call(task),
      child: Container(
        width: 70.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Image
            Container(
              height: 8.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: task["image"] as String? ?? "",
                  width: double.infinity,
                  height: 8.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 1.5.h),

            // Task Title
            Text(
              task["title"] as String? ?? "",
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),

            // Category and Price Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task["category"] as String? ?? "",
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  "\$${(task["price"] as double? ?? 0.0).toStringAsFixed(0)}",
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            // Distance and Rating
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 12,
                ),
                SizedBox(width: 1.w),
                Text(
                  task["distance"] as String? ?? "",
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.warningLight,
                  size: 12,
                ),
                SizedBox(width: 1.w),
                Text(
                  (task["rating"] as double? ?? 0.0).toStringAsFixed(1),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
