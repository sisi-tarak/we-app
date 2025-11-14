import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../subscription/subscription_selection_screen.dart';
import './widgets/registration_form.dart';
import './widgets/role_selection_chips.dart';
import './widgets/social_login_buttons.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();

  late AnimationController _progressAnimationController;
  late AnimationController _welcomeAnimationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _welcomeAnimation;

  String _selectedCountryCode = '+1';
  String _selectedRole = 'helper';
  bool _isPasswordVisible = false;
  bool _isTermsAccepted = false;
  bool _isLoading = false;
  int _currentStep = 1;
  final int _totalSteps = 3;

  // Mock user data for duplicate checking
  final List<Map<String, dynamic>> _existingUsers = [
    {
      'email': 'john.doe@example.com',
      'phone': '+15551234567',
      'name': 'John Doe',
    },
    {
      'email': 'sarah.wilson@gmail.com',
      'phone': '+14567890123',
      'name': 'Sarah Wilson',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _welcomeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _welcomeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.elasticOut,
    ));

    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    _progressAnimationController.dispose();
    _welcomeAnimationController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _fullNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _isTermsAccepted &&
        _formKey.currentState?.validate() == true;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid) {
      Fluttertoast.showToast(
        msg: "Please fill all fields correctly and accept terms",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check for duplicate email
      final email = _emailController.text.trim().toLowerCase();
      final phone = '$_selectedCountryCode${_phoneController.text.trim()}';

      final duplicateEmail = (_existingUsers as List).any((dynamic user) =>
          (user as Map<String, dynamic>)['email'].toString().toLowerCase() ==
          email);

      final duplicatePhone = (_existingUsers as List).any(
          (dynamic user) => (user as Map<String, dynamic>)['phone'] == phone);

      if (duplicateEmail) {
        throw Exception('An account with this email already exists');
      }

      if (duplicatePhone) {
        throw Exception('An account with this phone number already exists');
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success animation
      await _showWelcomeAnimation();

      // Navigate based on selected role
      if (mounted) {
        // If user selected "Task Poster" or "Both", show subscription selection
        if (_selectedRole == 'poster' || _selectedRole == 'both') {
          // Generate a mock user ID (in production, this would come from API response)
          final userId = email.hashCode.toString();
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SubscriptionSelectionScreen(
                userId: userId,
                selectedRole: _selectedRole,
              ),
            ),
          );
        } else {
          // For helpers only, go directly to home dashboard
          Navigator.pushReplacementNamed(context, '/home-dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: e.toString().replaceAll('Exception: ', ''),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          textColor: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showWelcomeAnimation() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AnimatedBuilder(
        animation: _welcomeAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _welcomeAnimation.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    size: 60,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Welcome to WE Community!',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Your account has been created successfully',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    _welcomeAnimationController.forward();
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);

    try {
      // Simulate social login API call
      await Future.delayed(const Duration(seconds: 1));

      Fluttertoast.showToast(
        msg: "$provider login successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        textColor: Colors.white,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: "$provider login failed. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          textColor: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleTermsPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 70.h,
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
              'Terms & Privacy Policy',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''Terms of Service

1. Acceptance of Terms
By using WE Community Tasks, you agree to these terms and conditions.

2. User Responsibilities
- Provide accurate information
- Complete tasks as agreed
- Maintain respectful communication
- Follow community guidelines

3. Payment Terms
- Payments are held in escrow until task completion
- Service fees apply to all transactions
- Refunds processed according to dispute resolution

4. Privacy Policy
We collect and use your information to:
- Facilitate task matching
- Process payments securely
- Improve our services
- Send important notifications

Your data is protected and never sold to third parties.

5. Community Guidelines
- Be respectful and professional
- Complete tasks on time
- Report any issues promptly
- Maintain safety standards

For full terms, visit our website or contact support.''',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    SizedBox(height: 4.h),
                    SocialLoginButtons(
                      onGooglePressed: _isLoading
                          ? null
                          : () => _handleSocialLogin('Google'),
                      onFacebookPressed: _isLoading
                          ? null
                          : () => _handleSocialLogin('Facebook'),
                      onApplePressed:
                          _isLoading ? null : () => _handleSocialLogin('Apple'),
                    ),
                    SizedBox(height: 4.h),
                    _buildDivider(),
                    SizedBox(height: 4.h),
                    RegistrationForm(
                      formKey: _formKey,
                      fullNameController: _fullNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      selectedCountryCode: _selectedCountryCode,
                      isPasswordVisible: _isPasswordVisible,
                      isTermsAccepted: _isTermsAccepted,
                      onCountryCodeChanged: (code) =>
                          setState(() => _selectedCountryCode = code),
                      onPasswordVisibilityToggle: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                      onTermsChanged: (value) =>
                          setState(() => _isTermsAccepted = value ?? false),
                      onTermsPressed: _handleTermsPressed,
                    ),
                    SizedBox(height: 4.h),
                    RoleSelectionChips(
                      selectedRole: _selectedRole,
                      onRoleSelected: (role) =>
                          setState(() => _selectedRole = role),
                    ),
                    SizedBox(height: 4.h),
                    _buildCreateAccountButton(),
                    SizedBox(height: 3.h),
                    _buildLoginLink(),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    Text(
                      'Step $_currentStep of $_totalSteps',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: (_currentStep / _totalSteps) *
                          _progressAnimation.value,
                      backgroundColor: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Join our community and start earning or getting help with tasks',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
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
            'Or create with email',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
    );
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading || !_isFormValid ? null : _handleRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          foregroundColor: Colors.white,
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Create Account',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/login-screen'),
        child: RichText(
          text: TextSpan(
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            children: [
              const TextSpan(text: 'Already have an account? '),
              TextSpan(
                text: 'Sign In',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
