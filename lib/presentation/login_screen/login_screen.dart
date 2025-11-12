import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo.dart';
import './widgets/login_form.dart';
import './widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // Mock credentials for testing
  final List<Map<String, String>> _mockCredentials = [
    {
      'email': 'helper@example.com',
      'password': 'helper123',
      'role': 'Helper',
    },
    {
      'email': 'poster@example.com',
      'password': 'poster123',
      'role': 'Task Poster',
    },
    {
      'email': 'admin@example.com',
      'password': 'admin123',
      'role': 'Admin',
    },
    {
      'email': '+1234567890',
      'password': 'phone123',
      'role': 'Helper',
    },
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Check mock credentials
      final validCredential = _mockCredentials.firstWhere(
        (cred) => cred['email'] == email && cred['password'] == password,
        orElse: () => {},
      );

      if (validCredential.isNotEmpty) {
        // Success - provide haptic feedback
        HapticFeedback.lightImpact();

        // Show success toast
        Fluttertoast.showToast(
          msg: 'Welcome back, ${validCredential['role']}!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          textColor: Colors.white,
        );

        // Navigate to home dashboard
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      } else {
        setState(() {
          _errorMessage =
              'Invalid email/phone or password. Please check your credentials and try again.';
        });

        // Error haptic feedback
        HapticFeedback.mediumImpact();

        // Show error toast
        Fluttertoast.showToast(
          msg: 'Login failed. Please check your credentials.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Network error. Please check your connection and try again.';
      });

      Fluttertoast.showToast(
        msg: 'Connection error. Please try again.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleSocialLogin(String provider) {
    Fluttertoast.showToast(
      msg: '$provider login will be available soon',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: Colors.white,
    );
  }

  void _handleForgotPassword() {
    Fluttertoast.showToast(
      msg: 'Password reset link sent to your email',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      textColor: Colors.white,
    );
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/registration-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 6.h),

                // App Logo
                const AppLogo(),
                SizedBox(height: 6.h),

                // Welcome Text
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Sign in to continue to your account',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 4.h),

                // Error Message
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    margin: EdgeInsets.only(bottom: 3.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.error,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'error',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme
                                  .lightTheme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Login Form
                LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isLoading: _isLoading,
                  onLogin: _handleLogin,
                  onForgotPassword: _handleForgotPassword,
                ),
                SizedBox(height: 4.h),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Social Login Buttons
                SocialLoginButton(
                  iconName: 'g_translate',
                  label: 'Continue with Google',
                  backgroundColor: Colors.white,
                  textColor: AppTheme.lightTheme.colorScheme.onSurface,
                  onPressed:
                      _isLoading ? () {} : () => _handleSocialLogin('Google'),
                ),
                SocialLoginButton(
                  iconName: 'apple',
                  label: 'Continue with Apple',
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed:
                      _isLoading ? () {} : () => _handleSocialLogin('Apple'),
                ),
                SocialLoginButton(
                  iconName: 'facebook',
                  label: 'Continue with Facebook',
                  backgroundColor: const Color(0xFF1877F2),
                  textColor: Colors.white,
                  onPressed:
                      _isLoading ? () {} : () => _handleSocialLogin('Facebook'),
                ),
                SizedBox(height: 4.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New user? ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : _navigateToSignUp,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
