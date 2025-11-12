import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './task_card_widget.dart';

class RecommendedTasksWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recommendedTasks;
  final bool isHelper;
  final Function(Map<String, dynamic>) onTaskTap;
  final Function(Map<String, dynamic>)? onTaskSave;

  const RecommendedTasksWidget({
    Key? key,
    required this.recommendedTasks,
    required this.isHelper,
    required this.onTaskTap,
    this.onTaskSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recommendedTasks.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHelper ? 'Recommended for You' : 'Similar Tasks',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildEmptyState(context),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHelper ? 'Recommended for You' : 'Similar Tasks',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to browse all tasks
                },
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 32.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  recommendedTasks.length > 5 ? 5 : recommendedTasks.length,
              itemBuilder: (context, index) {
                final task = recommendedTasks[index];
                return Container(
                  width: 80.w,
                  margin: EdgeInsets.only(right: 3.w),
                  child: TaskCardWidget(
                    task: task,
                    isHelper: isHelper,
                    onTap: () => onTaskTap(task),
                    onSave: onTaskSave != null ? () => onTaskSave!(task) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: isHelper ? 'recommend' : 'lightbulb_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            isHelper ? 'No recommendations yet' : 'No similar tasks found',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            isHelper
                ? 'Complete more tasks to get personalized recommendations'
                : 'Post more tasks to see similar opportunities',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          OutlinedButton(
            onPressed: () {
              if (isHelper) {
                // Navigate to browse all tasks
              } else {
                Navigator.pushNamed(context, '/task-posting-screen');
              }
            },
            child: Text(isHelper ? 'Browse All Tasks' : 'Post Another Task'),
          ),
        ],
      ),
    );
  }
}
