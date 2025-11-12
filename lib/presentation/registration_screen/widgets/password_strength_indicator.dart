import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength(password);
    final strengthText = _getStrengthText(strength);
    final strengthColor = _getStrengthColor(strength);

    return password.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: strength / 4,
                      backgroundColor: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                      minHeight: 4,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    strengthText,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: strengthColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              _buildRequirements(),
            ],
          );
  }

  Widget _buildRequirements() {
    final requirements = [
      {'text': 'At least 8 characters', 'met': password.length >= 8},
      {
        'text': 'Contains uppercase letter',
        'met': password.contains(RegExp(r'[A-Z]'))
      },
      {
        'text': 'Contains lowercase letter',
        'met': password.contains(RegExp(r'[a-z]'))
      },
      {'text': 'Contains number', 'met': password.contains(RegExp(r'[0-9]'))},
      {
        'text': 'Contains special character',
        'met': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
      },
    ];

    return Column(
      children: requirements.map((req) {
        final isMet = req['met'] as bool;
        return Padding(
          padding: EdgeInsets.only(bottom: 0.5.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: isMet ? 'check_circle' : 'radio_button_unchecked',
                size: 16,
                color: isMet
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  req['text'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isMet
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
      case 3:
        return 'Medium';
      case 4:
      case 5:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppTheme.lightTheme.colorScheme.error;
      case 2:
      case 3:
        return AppTheme.warningLight;
      case 4:
      case 5:
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.error;
    }
  }
}
