import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskRequirementsWidget extends StatefulWidget {
  final bool isExpanded;
  final Function(bool) onToggle;
  final Map<String, dynamic> requirements;
  final Function(Map<String, dynamic>) onRequirementsChanged;

  const TaskRequirementsWidget({
    Key? key,
    required this.isExpanded,
    required this.onToggle,
    required this.requirements,
    required this.onRequirementsChanged,
  }) : super(key: key);

  @override
  State<TaskRequirementsWidget> createState() => _TaskRequirementsWidgetState();
}

class _TaskRequirementsWidgetState extends State<TaskRequirementsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Column(
        children: [
          // Toggle Header
          GestureDetector(
            onTap: () => widget.onToggle(!widget.isExpanded),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Task Requirements (Optional)',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: widget.isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          if (widget.isExpanded) ...[
            Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Helper Age Range
                  _buildAgeRangeSection(),
                  SizedBox(height: 4.h),

                  // Verification Level
                  _buildVerificationSection(),
                  SizedBox(height: 4.h),

                  // Special Skills
                  _buildSpecialSkillsSection(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAgeRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Helper Age Range',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildAgeChip('18-25', 'young_adults'),
            _buildAgeChip('26-35', 'adults'),
            _buildAgeChip('36-50', 'experienced'),
            _buildAgeChip('50+', 'seniors'),
            _buildAgeChip('Any Age', 'any'),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeChip(String label, String value) {
    final bool isSelected = widget.requirements['ageRange'] == value;

    return GestureDetector(
      onTap: () {
        final Map<String, dynamic> updatedRequirements =
            Map.from(widget.requirements);
        updatedRequirements['ageRange'] = isSelected ? null : value;
        widget.onRequirementsChanged(updatedRequirements);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Level Required',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 2.h),
        _buildVerificationOption(
          'Basic',
          'basic',
          'Email and phone verified',
          'verified_user',
        ),
        SizedBox(height: 2.h),
        _buildVerificationOption(
          'Enhanced',
          'enhanced',
          'ID document verified',
          'security',
        ),
        SizedBox(height: 2.h),
        _buildVerificationOption(
          'Premium',
          'premium',
          'Background check completed',
          'shield',
        ),
      ],
    );
  }

  Widget _buildVerificationOption(
      String title, String value, String description, String iconName) {
    final bool isSelected = widget.requirements['verificationLevel'] == value;

    return GestureDetector(
      onTap: () {
        final Map<String, dynamic> updatedRequirements =
            Map.from(widget.requirements);
        updatedRequirements['verificationLevel'] = isSelected ? null : value;
        widget.onRequirementsChanged(updatedRequirements);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: isSelected
                  ? 'radio_button_checked'
                  : 'radio_button_unchecked',
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimaryContainer
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Skills Required',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 2.h),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'e.g., Must have own car, experience with pets, lifting heavy items...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ),
          onChanged: (value) {
            final Map<String, dynamic> updatedRequirements =
                Map.from(widget.requirements);
            updatedRequirements['specialSkills'] = value.isEmpty ? null : value;
            widget.onRequirementsChanged(updatedRequirements);
          },
        ),
        SizedBox(height: 3.h),
        Text(
          'Common Skills',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildSkillChip('Own Vehicle', 'vehicle'),
            _buildSkillChip('Pet Friendly', 'pets'),
            _buildSkillChip('Heavy Lifting', 'lifting'),
            _buildSkillChip('Tech Savvy', 'tech'),
            _buildSkillChip('Flexible Schedule', 'flexible'),
            _buildSkillChip('Tools Available', 'tools'),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillChip(String label, String value) {
    final List<String> selectedSkills =
        (widget.requirements['quickSkills'] as List<String>?) ?? [];
    final bool isSelected = selectedSkills.contains(value);

    return GestureDetector(
      onTap: () {
        final Map<String, dynamic> updatedRequirements =
            Map.from(widget.requirements);
        final List<String> currentSkills =
            (updatedRequirements['quickSkills'] as List<String>?) ?? [];

        if (isSelected) {
          currentSkills.remove(value);
        } else {
          currentSkills.add(value);
        }

        updatedRequirements['quickSkills'] = currentSkills;
        widget.onRequirementsChanged(updatedRequirements);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 14,
                ),
              ),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
