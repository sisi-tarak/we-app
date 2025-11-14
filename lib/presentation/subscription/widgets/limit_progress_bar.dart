import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_export.dart';

/// Custom progress bar widget for subscription limits with color thresholds
class LimitProgressBar extends StatelessWidget {
  final int used;
  final int limit;
  final int? carryoverBalance;

  const LimitProgressBar({
    Key? key,
    required this.used,
    required this.limit,
    this.carryoverBalance,
  }) : super(key: key);

  double get percentage => limit > 0 ? (used / limit) * 100 : 0.0;

  Color get _progressColor {
    if (percentage < 50) return const Color(0xFF4CAF50); // Green
    if (percentage < 80) return const Color(0xFFFFC107); // Yellow
    return const Color(0xFFF44336); // Red
  }

  @override
  Widget build(BuildContext context) {
    final available = limit + (carryoverBalance ?? 0) - used;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Labels row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${used.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} used',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            Text(
              '₹${available.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} available',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),

        // Progress bar
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage > 100 ? 1.0 : percentage / 100,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: _progressColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),

        // Percentage text
        Text(
          '${percentage.toStringAsFixed(1)}% consumed',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

