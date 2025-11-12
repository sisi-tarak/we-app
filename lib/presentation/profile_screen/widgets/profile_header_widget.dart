import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditPhoto;

  const ProfileHeaderWidget({
    Key? key,
    required this.userData,
    required this.onEditPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userData['avatar'] as String? ??
                        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
                    width: 25.w,
                    height: 25.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditPhoto,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 4.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            userData['name'] as String? ?? 'User Name',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          _buildRoleBadges(),
          SizedBox(height: 2.h),
          _buildRatingSection(),
        ],
      ),
    );
  }

  Widget _buildRoleBadges() {
    final List<String> roles =
        (userData['roles'] as List?)?.cast<String>() ?? ['Helper'];

    return Wrap(
      spacing: 2.w,
      children: roles
          .map((role) => Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Text(
                  role,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildRatingSection() {
    final double rating = (userData['rating'] as num?)?.toDouble() ?? 4.5;
    final int reviewCount = userData['reviewCount'] as int? ?? 127;
    final int completedTasks = userData['completedTasks'] as int? ?? 89;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: 'star',
          value: rating.toStringAsFixed(1),
          label: '$reviewCount reviews',
        ),
        Container(
          width: 1,
          height: 4.h,
          color: Colors.white.withValues(alpha: 0.3),
        ),
        _buildStatItem(
          icon: 'task_alt',
          value: completedTasks.toString(),
          label: 'Completed',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
