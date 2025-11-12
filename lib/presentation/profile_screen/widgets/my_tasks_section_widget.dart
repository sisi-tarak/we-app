import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MyTasksSectionWidget extends StatelessWidget {
  final Map<String, dynamic> taskCounts;
  final VoidCallback onViewActiveTasks;
  final VoidCallback onViewCompletedTasks;
  final VoidCallback onViewSavedTasks;

  const MyTasksSectionWidget({
    Key? key,
    required this.taskCounts,
    required this.onViewActiveTasks,
    required this.onViewCompletedTasks,
    required this.onViewSavedTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int activeTasks = taskCounts['active'] as int? ?? 3;
    final int completedTasks = taskCounts['completed'] as int? ?? 89;
    final int savedTasks = taskCounts['saved'] as int? ?? 12;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'My Tasks',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildTaskItem(
            icon: 'pending_actions',
            title: 'Active Tasks',
            count: activeTasks,
            color: AppTheme.lightTheme.colorScheme.tertiary,
            onTap: onViewActiveTasks,
          ),
          _buildDivider(),
          _buildTaskItem(
            icon: 'task_alt',
            title: 'Completed Tasks',
            count: completedTasks,
            color: AppTheme.lightTheme.primaryColor,
            onTap: onViewCompletedTasks,
          ),
          _buildDivider(),
          _buildTaskItem(
            icon: 'bookmark',
            title: 'Saved Tasks',
            count: savedTasks,
            color: AppTheme.lightTheme.colorScheme.secondary,
            onTap: onViewSavedTasks,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem({
    required String icon,
    required String title,
    required int count,
    required Color color,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isLast ? 12 : 0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 17.w),
      child: Divider(
        height: 1,
        color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
      ),
    );
  }
}
