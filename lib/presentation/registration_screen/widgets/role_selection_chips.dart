import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoleSelectionChips extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleSelected;

  const RoleSelectionChips({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final roles = [
      {'value': 'poster', 'label': 'Task Poster', 'icon': 'post_add'},
      {'value': 'helper', 'label': 'Helper', 'icon': 'handyman'},
      {'value': 'both', 'label': 'Both', 'icon': 'people'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I want to be a:',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: roles.map((role) {
            final isSelected = selectedRole == role['value'];
            return GestureDetector(
              onTap: () => onRoleSelected(role['value'] as String),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: role['icon'] as String,
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      role['label'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
