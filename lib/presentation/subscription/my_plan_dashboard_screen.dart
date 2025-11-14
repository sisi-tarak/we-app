import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_export.dart';
import '../../providers/subscription_provider.dart';
import 'widgets/limit_progress_bar.dart';
import 'widgets/carryover_balance_widget.dart';
import 'subscription_selection_screen.dart';

/// Dashboard screen for managing subscription (Profile → My Subscription)
class MyPlanDashboardScreen extends StatefulWidget {
  final String userId;

  const MyPlanDashboardScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<MyPlanDashboardScreen> createState() => _MyPlanDashboardScreenState();
}

class _MyPlanDashboardScreenState extends State<MyPlanDashboardScreen> {
  final SubscriptionProvider _subscriptionProvider = SubscriptionProvider();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    setState(() => _isLoading = true);
    await _subscriptionProvider.fetchSubscriptionStatus(widget.userId);
    setState(() => _isLoading = false);
  }

  Future<void> _handleUpgrade() async {
    final nextTier = _subscriptionProvider.getNextTier();
    if (nextTier == null) {
      Fluttertoast.showToast(
        msg: 'You are already on the highest tier',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Upgrade to ${nextTier.name}',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to upgrade to ${nextTier.name} (₹${nextTier.price.toInt()}/month)?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'New monthly limit: ₹${nextTier.monthlyLimit.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      final success = await _subscriptionProvider.upgradeSubscription(
        userId: widget.userId,
        newTierId: nextTier.id,
      );
      setState(() => _isLoading = false);

      if (success && mounted) {
        Fluttertoast.showToast(
          msg: 'Successfully upgraded to ${nextTier.name}!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          textColor: Colors.white,
        );
        await _loadSubscriptionStatus();
      }
    }
  }

  void _handleManageBilling() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening payment method editor...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleRenewalSettings() {
    final currentStatus = _subscriptionProvider.subscriptionStatus;
    if (currentStatus == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Auto-Renewal Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            bool autoRenewal = currentStatus.autoRenewal;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Auto-Renewal'),
                  value: autoRenewal,
                  onChanged: (value) {
                    setState(() {
                      autoRenewal = value;
                    });
                  },
                ),
                if (!autoRenewal)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      'Your subscription will expire on ${_formatDate(currentStatus.renewalDate)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Renewal settings updated',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                textColor: Colors.white,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final status = _subscriptionProvider.subscriptionStatus;
    final nextTier = _subscriptionProvider.getNextTier();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'My Subscription',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      ),
      body: SafeArea(
        child: _isLoading && status == null
            ? const Center(child: CircularProgressIndicator())
            : status == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.subscriptions,
                          size: 15.w,
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'No active subscription',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 2.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubscriptionSelectionScreen(
                                  userId: widget.userId,
                                ),
                              ),
                            ).then((_) => _loadSubscriptionStatus());
                          },
                          child: const Text('Select a Plan'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadSubscriptionStatus,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current Plan Card
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              gradient: status.currentTier.bgColor == 'gradient'
                                  ? const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFFFF8C42), Color(0xFFFFA85C)],
                                    )
                                  : null,
                              color: status.currentTier.bgColor == 'gradient'
                                  ? null
                                  : Color(int.parse(status.currentTier.bgColor.replaceAll('#', '0xFF'))),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Plan',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  '${status.currentTier.name} (₹${status.currentTier.price.toInt()}/month)',
                                  style: GoogleFonts.inter(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Renewal Date: ${_formatDate(status.renewalDate)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),

                          // Monthly Limit Status
                          Text(
                            'Monthly Limit Status',
                            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          LimitProgressBar(
                            used: status.usedThisMonth,
                            limit: status.monthlyLimit,
                            carryoverBalance: status.carryoverBalance,
                          ),
                          SizedBox(height: 4.h),

                          // Carry-over Balance
                          if (status.carryoverBalance > 0)
                            CarryoverBalanceWidget(
                              carryoverBalance: status.carryoverBalance,
                              expiryDate: status.carryoverExpiryDate,
                            ),
                          if (status.carryoverBalance > 0) SizedBox(height: 4.h),

                          // Action Buttons
                          if (nextTier != null) ...[
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _handleUpgrade,
                                icon: const Icon(Icons.arrow_upward),
                                label: Text('Upgrade to ${nextTier.name}'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _handleManageBilling,
                              icon: const Icon(Icons.payment),
                              label: const Text('Manage Billing'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _handleRenewalSettings,
                              icon: const Icon(Icons.settings),
                              label: const Text('Auto-Renewal Settings'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),

                          // FAQ Link
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Opening FAQ...'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.help_outline),
                              label: const Text('Frequently Asked Questions'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

