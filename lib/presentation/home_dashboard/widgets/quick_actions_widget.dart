import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final bool isHelper;
  final VoidCallback onPostTask;
  final VoidCallback onFindTasks;

  const QuickActionsWidget({
    Key? key,
    required this.isHelper,
    required this.onPostTask,
    required this.onFindTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: isHelper ? 'Find Tasks' : 'Post Task',
                  subtitle: isHelper
                      ? 'Browse available tasks'
                      : 'Get help with your tasks',
                  iconName: isHelper ? 'search' : 'add_circle',
                  color: AppTheme.lightTheme.primaryColor,
                  onTap: isHelper ? onFindTasks : onPostTask,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: isHelper ? 'My Applications' : 'My Tasks',
                  subtitle: isHelper
                      ? 'Track your applications'
                      : 'Manage your posted tasks',
                  iconName: isHelper ? 'assignment' : 'task_alt',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  onTap: () {
                    Navigator.pushNamed(context, '/profile-screen');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconName,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
