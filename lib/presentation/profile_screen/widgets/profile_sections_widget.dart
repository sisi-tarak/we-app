import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSectionsWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditBio;

  const ProfileSectionsWidget({
    Key? key,
    required this.userData,
    required this.onEditBio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAboutMeSection(),
        SizedBox(height: 2.h),
        _buildVerificationSection(),
        SizedBox(height: 2.h),
        _buildSkillsSection(),
      ],
    );
  }

  Widget _buildAboutMeSection() {
    final String bio = userData['bio'] as String? ??
        'Passionate helper dedicated to making life easier for my community. Available for various tasks and always ready to lend a helping hand!';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About Me',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onEditBio,
                child: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            bio,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    final bool isIdVerified = userData['isIdVerified'] as bool? ?? false;
    final bool isBackgroundChecked =
        userData['isBackgroundChecked'] as bool? ?? false;
    final double verificationProgress =
        userData['verificationProgress'] as double? ?? 0.6;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Verification Status',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(verificationProgress * 100).toInt()}%',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: verificationProgress,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 2.h),
          _buildVerificationItem(
            'ID Verification',
            isIdVerified,
            'identity_verification',
          ),
          SizedBox(height: 1.h),
          _buildVerificationItem(
            'Background Check',
            isBackgroundChecked,
            'verified_user',
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationItem(
      String title, bool isVerified, String iconName) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: isVerified
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: isVerified
                ? AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isVerified ? 'Verified' : 'Pending',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isVerified
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    final List<String> skills = (userData['skills'] as List?)?.cast<String>() ??
        ['Cleaning', 'Delivery', 'Pet Care', 'Handyman', 'Tutoring'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Skills & Categories',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: skills
                .map((skill) => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        skill,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
