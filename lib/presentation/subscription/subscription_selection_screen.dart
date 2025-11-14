import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../models/subscription_tier.dart';
import '../../providers/subscription_provider.dart';
import 'widgets/subscription_tier_card.dart';

/// Screen for selecting subscription tier (first-time posters)
class SubscriptionSelectionScreen extends StatefulWidget {
  final String userId;
  final String? selectedRole;

  const SubscriptionSelectionScreen({
    Key? key,
    required this.userId,
    this.selectedRole,
  }) : super(key: key);

  @override
  State<SubscriptionSelectionScreen> createState() => _SubscriptionSelectionScreenState();
}

class _SubscriptionSelectionScreenState extends State<SubscriptionSelectionScreen> {
  final SubscriptionProvider _subscriptionProvider = SubscriptionProvider();
  String? _selectedTierId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTiers();
  }

  Future<void> _loadTiers() async {
    setState(() => _isLoading = true);
    await _subscriptionProvider.fetchSubscriptionTiers();
    setState(() => _isLoading = false);
  }

  Future<void> _handleTierSelection(String tierId) async {
    setState(() => _selectedTierId = tierId);
    
    // Show confirmation with animation
    HapticFeedback.lightImpact();
    
    // Auto-select after brief delay to show selection feedback
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _handleConfirmSelection() async {
    if (_selectedTierId == null) {
      Fluttertoast.showToast(
        msg: 'Please select a subscription plan',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await _subscriptionProvider.selectSubscriptionTier(
      userId: widget.userId,
      tierId: _selectedTierId!,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      HapticFeedback.mediumImpact();
      
      Fluttertoast.showToast(
        msg: 'Subscription plan selected successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        textColor: Colors.white,
      );

      // Navigate to home dashboard
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else if (mounted) {
      Fluttertoast.showToast(
        msg: _subscriptionProvider.errorMessage ?? 'Failed to select plan',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Choose Your Plan',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      ),
      body: SafeArea(
        child: _isLoading && _subscriptionProvider.tiers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Header section
                  Container(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      children: [
                        Text(
                          'Select Your Subscription Plan',
                          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Choose a plan that fits your task posting needs. You can upgrade anytime.',
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Tiers list
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isTablet = constraints.maxWidth > 600;
                        return isTablet
                            ? _buildTabletLayout()
                            : _buildMobileLayout();
                      },
                    ),
                  ),

                  // Continue button
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleConfirmSelection,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 2.h,
                                  width: 2.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Continue with Selected Plan',
                                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      children: _subscriptionProvider.tiers.map((tier) {
        return SubscriptionTierCard(
          tier: tier,
          isSelected: _selectedTierId == tier.id,
          onTap: () => _handleTierSelection(tier.id),
        );
      }).toList(),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _subscriptionProvider.tiers.map((tier) {
          return Expanded(
            child: SubscriptionTierCard(
              tier: tier,
              isSelected: _selectedTierId == tier.id,
              onTap: () => _handleTierSelection(tier.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}

