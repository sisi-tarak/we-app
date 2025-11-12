import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onVerificationCenter;
  final VoidCallback onHelpSupport;
  final VoidCallback onLogout;

  const AccountActionsWidget({
    Key? key,
    required this.onEditProfile,
    required this.onVerificationCenter,
    required this.onHelpSupport,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
            children: [
              _buildActionItem(
                icon: 'edit',
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: onEditProfile,
                color: AppTheme.lightTheme.primaryColor,
              ),
              _buildDivider(),
              _buildActionItem(
                icon: 'verified_user',
                title: 'Verification Center',
                subtitle: 'Complete your account verification',
                onTap: onVerificationCenter,
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
              _buildDivider(),
              _buildActionItem(
                icon: 'help_outline',
                title: 'Help & Support',
                subtitle: 'Get help or contact support',
                onTap: onHelpSupport,
                color: AppTheme.lightTheme.colorScheme.secondary,
                isLast: true,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
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
          child: _buildActionItem(
            icon: 'logout',
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: onLogout,
            color: AppTheme.lightTheme.colorScheme.error,
            isLast: true,
          ),
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildActionItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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
