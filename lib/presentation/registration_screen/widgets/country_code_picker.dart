import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CountryCodePicker extends StatelessWidget {
  final String selectedCountryCode;
  final Function(String) onCountryCodeSelected;

  const CountryCodePicker({
    super.key,
    required this.selectedCountryCode,
    required this.onCountryCodeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getCountryFlag(selectedCountryCode),
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(width: 1.w),
            Text(
              selectedCountryCode,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              size: 20,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    final countries = [
      {'code': '+1', 'name': 'United States', 'flag': '🇺🇸'},
      {'code': '+44', 'name': 'United Kingdom', 'flag': '🇬🇧'},
      {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
      {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
      {'code': '+81', 'name': 'Japan', 'flag': '🇯🇵'},
      {'code': '+49', 'name': 'Germany', 'flag': '🇩🇪'},
      {'code': '+33', 'name': 'France', 'flag': '🇫🇷'},
      {'code': '+39', 'name': 'Italy', 'flag': '🇮🇹'},
      {'code': '+34', 'name': 'Spain', 'flag': '🇪🇸'},
      {'code': '+7', 'name': 'Russia', 'flag': '🇷🇺'},
      {'code': '+55', 'name': 'Brazil', 'flag': '🇧🇷'},
      {'code': '+61', 'name': 'Australia', 'flag': '🇦🇺'},
      {'code': '+82', 'name': 'South Korea', 'flag': '🇰🇷'},
      {'code': '+52', 'name': 'Mexico', 'flag': '🇲🇽'},
      {'code': '+27', 'name': 'South Africa', 'flag': '🇿🇦'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Country Code',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  return ListTile(
                    leading: Text(
                      country['flag'] as String,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    title: Text(
                      country['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    trailing: Text(
                      country['code'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      onCountryCodeSelected(country['code'] as String);
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

  String _getCountryFlag(String countryCode) {
    switch (countryCode) {
      case '+1':
        return '🇺🇸';
      case '+44':
        return '🇬🇧';
      case '+91':
        return '🇮🇳';
      case '+86':
        return '🇨🇳';
      case '+81':
        return '🇯🇵';
      case '+49':
        return '🇩🇪';
      case '+33':
        return '🇫🇷';
      case '+39':
        return '🇮🇹';
      case '+34':
        return '🇪🇸';
      case '+7':
        return '🇷🇺';
      case '+55':
        return '🇧🇷';
      case '+61':
        return '🇦🇺';
      case '+82':
        return '🇰🇷';
      case '+52':
        return '🇲🇽';
      case '+27':
        return '🇿🇦';
      default:
        return '🇺🇸';
    }
  }
}
