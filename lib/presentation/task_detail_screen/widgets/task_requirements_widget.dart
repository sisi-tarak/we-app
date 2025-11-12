import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class TaskRequirementsWidget extends StatelessWidget {
  final List<String> requirements;
  final String? agePreference;
  final List<String> verificationNeeds;

  const TaskRequirementsWidget({
    Key? key,
    required this.requirements,
    this.agePreference,
    required this.verificationNeeds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (requirements.isEmpty &&
        agePreference == null &&
        verificationNeeds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'checklist',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Requirements',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Skills Requirements
          if (requirements.isNotEmpty) ...[
            Text(
              'Skills & Experience:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            ...requirements.map((requirement) => Padding(
                  padding: EdgeInsets.only(bottom: 0.8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.3.h),
                        child: CustomIconWidget(
                          iconName: 'check_circle_outline',
                          color: AppTheme.successLight,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          requirement,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
            if (agePreference != null || verificationNeeds.isNotEmpty)
              SizedBox(height: 2.h),
          ],

          // Age Preference
          if (agePreference != null) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Age Preference: ',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  agePreference!,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (verificationNeeds.isNotEmpty) SizedBox(height: 1.5.h),
          ],

          // Verification Requirements
          if (verificationNeeds.isNotEmpty) ...[
            Text(
              'Verification Required:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: verificationNeeds
                  .map((verification) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.8.h),
                        decoration: BoxDecoration(
                          color: AppTheme.warningLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.warningLight.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'verified_user',
                              color: AppTheme.warningLight,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              verification,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.warningLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
