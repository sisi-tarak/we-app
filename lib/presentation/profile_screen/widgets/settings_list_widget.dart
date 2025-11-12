import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsListWidget extends StatelessWidget {
  final VoidCallback onAccountPreferences;
  final VoidCallback onNotificationSettings;
  final VoidCallback onPaymentMethods;
  final VoidCallback onPrivacySettings;

  const SettingsListWidget({
    Key? key,
    required this.onAccountPreferences,
    required this.onNotificationSettings,
    required this.onPaymentMethods,
    required this.onPrivacySettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              'Settings',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildSettingItem(
            icon: 'account_circle',
            title: 'Account Preferences',
            subtitle: 'Manage your account settings',
            onTap: onAccountPreferences,
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: 'notifications',
            title: 'Notification Controls',
            subtitle: 'Customize your notifications',
            onTap: onNotificationSettings,
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: 'payment',
            title: 'Payment Methods',
            subtitle: 'Manage cards and payment options',
            onTap: onPaymentMethods,
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: 'privacy_tip',
            title: 'Privacy Options',
            subtitle: 'Control your privacy settings',
            onTap: onPrivacySettings,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String icon,
    required String title,
    required String subtitle,
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
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.primaryColor,
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
