import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './country_code_picker.dart';
import './password_strength_indicator.dart';

class RegistrationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String selectedCountryCode;
  final bool isPasswordVisible;
  final bool isTermsAccepted;
  final Function(String) onCountryCodeChanged;
  final VoidCallback onPasswordVisibilityToggle;
  final Function(bool?) onTermsChanged;
  final VoidCallback onTermsPressed;

  const RegistrationForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.selectedCountryCode,
    required this.isPasswordVisible,
    required this.isTermsAccepted,
    required this.onCountryCodeChanged,
    required this.onPasswordVisibilityToggle,
    required this.onTermsChanged,
    required this.onTermsPressed,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFullNameField(),
          SizedBox(height: 3.h),
          _buildEmailField(),
          SizedBox(height: 3.h),
          _buildPhoneField(),
          SizedBox(height: 3.h),
          _buildPasswordField(),
          PasswordStrengthIndicator(password: widget.passwordController.text),
          SizedBox(height: 3.h),
          _buildTermsCheckbox(),
        ],
      ),
    );
  }

  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.fullNameController,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
              return 'Name can only contain letters and spaces';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email address';
            }
            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CountryCodePicker(
              selectedCountryCode: widget.selectedCountryCode,
              onCountryCodeSelected: widget.onCountryCodeChanged,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: TextFormField(
                controller: widget.phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'phone',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.trim().length < 7 || value.trim().length > 15) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.passwordController,
          obscureText: !widget.isPasswordVisible,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Create a strong password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: widget.onPasswordVisibilityToggle,
              icon: CustomIconWidget(
                iconName:
                    widget.isPasswordVisible ? 'visibility_off' : 'visibility',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (!RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
                .hasMatch(value)) {
              return 'Password must contain uppercase, lowercase, number and special character';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: widget.isTermsAccepted,
          onChanged: widget.onTermsChanged,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => widget.onTermsChanged(!widget.isTermsAccepted),
            child: Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: widget.onTermsPressed,
                        child: Text(
                          'Terms & Conditions',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: widget.onTermsPressed,
                        child: Text(
                          'Privacy Policy',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
