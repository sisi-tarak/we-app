import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onForgotPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = value.isEmpty ||
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value) ||
          RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value);
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.isEmpty || value.length >= 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email/Phone Field
          TextFormField(
            controller: widget.emailController,
            enabled: !widget.isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: _validateEmail,
            decoration: InputDecoration(
              labelText: 'Email or Phone',
              hintText: 'Enter your email or phone number',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: _isEmailValid
                      ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      : AppTheme.lightTheme.colorScheme.error,
                  size: 20,
                ),
              ),
              errorText: !_isEmailValid
                  ? 'Please enter a valid email or phone number'
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isEmailValid
                      ? AppTheme.lightTheme.colorScheme.outline
                      : AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isEmailValid
                      ? AppTheme.lightTheme.colorScheme.outline
                      : AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isEmailValid
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or phone number';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value) &&
                  !RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                return 'Please enter a valid email or phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: widget.passwordController,
            enabled: !widget.isLoading,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            onChanged: _validatePassword,
            onFieldSubmitted: (_) => widget.onLogin(),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: _isPasswordValid
                      ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      : AppTheme.lightTheme.colorScheme.error,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: widget.isLoading
                    ? null
                    : () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              errorText: !_isPasswordValid
                  ? 'Password must be at least 6 characters'
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isPasswordValid
                      ? AppTheme.lightTheme.colorScheme.outline
                      : AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isPasswordValid
                      ? AppTheme.lightTheme.colorScheme.outline
                      : AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isPasswordValid
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),

          // Login Button
          Container(
            width: double.infinity,
            height: 12.h,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppTheme.lightTheme.colorScheme.shadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
