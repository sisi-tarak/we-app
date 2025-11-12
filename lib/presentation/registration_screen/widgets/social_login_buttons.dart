import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Or continue with',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              onPressed: onGooglePressed,
              icon: 'g_translate',
              label: 'Google',
              backgroundColor: Colors.white,
              borderColor: AppTheme.lightTheme.colorScheme.outline,
            ),
            _buildSocialButton(
              onPressed: onFacebookPressed,
              icon: 'facebook',
              label: 'Facebook',
              backgroundColor: const Color(0xFF1877F2),
              textColor: Colors.white,
            ),
            if (Theme.of(context).platform == TargetPlatform.iOS)
              _buildSocialButton(
                onPressed: onApplePressed,
                icon: 'apple',
                label: 'Apple',
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onPressed,
    required String icon,
    required String label,
    required Color backgroundColor,
    Color? borderColor,
    Color? textColor,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor:
                textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
            elevation: 1,
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: borderColor != null
                  ? BorderSide(color: borderColor, width: 1)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: icon,
                size: 20,
                color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
              ),
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
