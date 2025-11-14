import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_export.dart';
import '../../../models/subscription_tier.dart';

/// Reusable subscription tier card widget
class SubscriptionTierCard extends StatefulWidget {
  final SubscriptionTier tier;
  final bool isSelected;
  final VoidCallback onTap;

  const SubscriptionTierCard({
    Key? key,
    required this.tier,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SubscriptionTierCard> createState() => _SubscriptionTierCardState();
}

class _SubscriptionTierCardState extends State<SubscriptionTierCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGradient = widget.tier.bgColor == 'gradient';
    final isRecommended = widget.tier.isRecommended;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _scaleAnimation.value : 1.0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                gradient: isGradient
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFF8C42), Color(0xFFFFA85C)],
                      )
                    : null,
                color: isGradient
                    ? null
                    : Color(int.parse(widget.tier.bgColor.replaceAll('#', '0xFF'))),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  width: widget.isSelected ? 2 : 0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: widget.isSelected ? 12 : 8,
                    offset: Offset(0, widget.isSelected ? 4 : 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recommended badge
                        if (isRecommended)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'RECOMMENDED',
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        if (isRecommended) SizedBox(height: 2.h),

                        // Plan name
                        Text(
                          widget.tier.name,
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: isGradient
                                ? Colors.white
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),

                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: isGradient
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${widget.tier.price.toInt()}',
                              style: GoogleFonts.inter(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: isGradient
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '/month',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: isGradient
                                ? Colors.white.withValues(alpha: 0.8)
                                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Benefits list
                        ..._buildBenefits(isGradient),
                        const Spacer(),

                        // Choose plan button
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: widget.isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 5.w,
                                ),
                              if (widget.isSelected) SizedBox(width: 2.w),
                              Text(
                                widget.isSelected ? 'Selected' : 'Choose Plan',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildBenefits(bool isGradient) {
    final benefits = [
      {
        'icon': Icons.account_balance_wallet,
        'text': 'Monthly Limit: ₹${widget.tier.monthlyLimit.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
      },
      {
        'icon': Icons.percent,
        'text': 'No Commission (within limit)',
      },
      {
        'icon': widget.tier.verifiedBadge ? Icons.verified : Icons.verified_outlined,
        'text': 'Verified Badge: ${widget.tier.verifiedBadge ? "Yes" : "No"}',
      },
      {
        'icon': Icons.support_agent,
        'text': 'Support: ${widget.tier.supportLevel}',
      },
      {
        'icon': widget.tier.advancedAnalytics
            ? Icons.analytics
            : Icons.analytics_outlined,
        'text': 'Advanced Analytics: ${widget.tier.advancedAnalytics ? "Yes" : "No"}',
      },
      {
        'icon': Icons.refresh,
        'text': 'Carry-over: Up to ${widget.tier.carryoverMonths} months',
      },
    ];

    return benefits.map((benefit) {
      return Padding(
        padding: EdgeInsets.only(bottom: 1.5.h),
        child: Row(
          children: [
            Icon(
              benefit['icon'] as IconData,
              size: 5.w,
              color: isGradient
                  ? Colors.white.withValues(alpha: 0.9)
                  : AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                benefit['text'] as String,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isGradient
                      ? Colors.white.withValues(alpha: 0.95)
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

