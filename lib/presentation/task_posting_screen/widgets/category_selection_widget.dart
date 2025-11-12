import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySelectionWidget extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelectionWidget({
    Key? key,
    this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCategoryBottomSheet(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
          color: AppTheme.lightTheme.colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedCategory ?? 'Select Category',
                style: selectedCategory != null
                    ? AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      )
                    : AppTheme.lightTheme.inputDecorationTheme.hintStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Home & Garden', 'icon': 'home'},
      {'name': 'Delivery & Moving', 'icon': 'local_shipping'},
      {'name': 'Handyman Services', 'icon': 'build'},
      {'name': 'Cleaning', 'icon': 'cleaning_services'},
      {'name': 'Pet Care', 'icon': 'pets'},
      {'name': 'Personal Assistant', 'icon': 'person'},
      {'name': 'Tech Support', 'icon': 'computer'},
      {'name': 'Tutoring', 'icon': 'school'},
      {'name': 'Event Help', 'icon': 'event'},
      {'name': 'Shopping', 'icon': 'shopping_cart'},
      {'name': 'Photography', 'icon': 'camera_alt'},
      {'name': 'Other', 'icon': 'more_horiz'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Select Category',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: categories.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category['name'];

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 1.h,
                    ),
                    leading: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: category['icon'],
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      category['name'],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      onCategorySelected(category['name']);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
