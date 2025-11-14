import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_export.dart';
import '../../../models/subscription_status.dart';
import '../../../models/subscription_tier.dart';

/// Dialog shown when task cost exceeds subscription limit
class OverLimitAlertDialog extends StatelessWidget {
  final SubscriptionStatus subscriptionStatus;
  final int taskCost;
  final Function() onUpgrade;
  final Function() onContinueWithCommission;

  const OverLimitAlertDialog({
    Key? key,
    required this.subscriptionStatus,
    required this.taskCost,
    required this.onUpgrade,
    required this.onContinueWithCommission,
  }) : super(key: key);

  double get commissionAmount => subscriptionStatus.calculateCommission(taskCost);
  double get totalCost => subscriptionStatus.calculateTotalWithCommission(taskCost);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Upgrade Your Plan or Continue?',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your current plan doesn\'t cover this task. Choose an option:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),

            // Task cost breakdown
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCostRow(
                    label: 'Task Cost',
                    amount: taskCost,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  SizedBox(height: 1.h),
                  Divider(height: 1),
                  SizedBox(height: 1.h),
                  _buildCostRow(
                    label: 'Platform Commission (6%)',
                    amount: commissionAmount.toInt(),
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                  SizedBox(height: 1.h),
                  Divider(height: 1, thickness: 2),
                  SizedBox(height: 1.h),
                  _buildCostRow(
                    label: 'Total to Deduct',
                    amount: totalCost.toInt(),
                    color: AppTheme.lightTheme.colorScheme.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Option 1: Upgrade
            _buildOptionCard(
              context: context,
              icon: Icons.upgrade,
              title: 'Upgrade to Next Tier',
              description: _getUpgradeDescription(),
              onTap: () {
                Navigator.pop(context);
                onUpgrade();
              },
              isPrimary: true,
            ),
            SizedBox(height: 2.h),

            // Option 2: Continue with commission
            _buildOptionCard(
              context: context,
              icon: Icons.payment,
              title: 'Pay 6% Commission',
              description: 'Add ₹${commissionAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} commission on top of task cost',
              onTap: () {
                Navigator.pop(context);
                onContinueWithCommission();
              },
              isPrimary: false,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCostRow({
    required String label,
    required int amount,
    required Color color,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
        Text(
          '₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppTheme.lightTheme.colorScheme.primaryContainer.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isPrimary
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isPrimary ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isPrimary
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isPrimary
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 4.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  String _getUpgradeDescription() {
    // This would ideally check for next tier availability
    // For now, return a generic message
    return 'Get more monthly limit + additional benefits';
  }
}

/// Helper function to show over-limit alert dialog
Future<void> showOverLimitAlert({
  required BuildContext context,
  required SubscriptionStatus subscriptionStatus,
  required int taskCost,
  required Function() onUpgrade,
  required Function() onContinueWithCommission,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => OverLimitAlertDialog(
      subscriptionStatus: subscriptionStatus,
      taskCost: taskCost,
      onUpgrade: onUpgrade,
      onContinueWithCommission: onContinueWithCommission,
    ),
  );
}

