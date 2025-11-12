import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const AchievementSectionWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> badges =
        (userData['badges'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final int points = userData['points'] as int? ?? 1250;
    final int leaderboardRank = userData['leaderboardRank'] as int? ?? 15;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildPointsCard(points),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildRankCard(leaderboardRank),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Earned Badges',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          badges.isEmpty ? _buildNoBadges() : _buildBadgesList(badges),
        ],
      ),
    );
  }

  Widget _buildPointsCard(int points) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'stars',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            points.toString(),
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Points',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard(int rank) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'leaderboard',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            '#$rank',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Rank',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoBadges() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'workspace_premium',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'No badges earned yet',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'Complete more tasks to earn badges!',
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesList(List<Map<String, dynamic>> badges) {
    return SizedBox(
      height: 12.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          return Container(
            width: 20.w,
            margin: EdgeInsets.only(right: 3.w),
            child: Column(
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: badge['icon'] as String? ?? 'military_tech',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 7.w,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  badge['name'] as String? ?? 'Badge',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
