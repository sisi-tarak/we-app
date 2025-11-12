import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewsSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewsSectionWidget({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  @override
  State<ReviewsSectionWidget> createState() => _ReviewsSectionWidgetState();
}

class _ReviewsSectionWidgetState extends State<ReviewsSectionWidget> {
  final Set<int> _expandedReviews = {};

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return _buildNoReviews();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Reviews',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${widget.reviews.length} reviews',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.reviews.length > 3 ? 3 : widget.reviews.length,
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            itemBuilder: (context, index) {
              final review = widget.reviews[index];
              return _buildReviewItem(review, index);
            },
          ),
          if (widget.reviews.length > 3)
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to full reviews page
                  },
                  child: Text(
                    'View All Reviews',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoReviews() {
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
        children: [
          CustomIconWidget(
            iconName: 'rate_review',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Reviews Yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete tasks to receive your first review!',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review, int index) {
    final bool isExpanded = _expandedReviews.contains(index);
    final String reviewText = review['comment'] as String? ?? '';
    final bool needsExpansion = reviewText.length > 100;
    final String displayText = needsExpansion && !isExpanded
        ? '${reviewText.substring(0, 100)}...'
        : reviewText;

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: review['reviewerAvatar'] as String? ??
                        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face',
                    width: 10.w,
                    height: 10.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['reviewerName'] as String? ?? 'Anonymous User',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        _buildStarRating(review['rating'] as double? ?? 5.0),
                        SizedBox(width: 2.w),
                        Text(
                          review['date'] as String? ?? '2 days ago',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            displayText,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          if (needsExpansion)
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedReviews.remove(index);
                  } else {
                    _expandedReviews.add(index);
                  }
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Text(
                  isExpanded ? 'Show less' : 'Read more',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return CustomIconWidget(
          iconName: index < rating.floor() ? 'star' : 'star_border',
          color: index < rating.floor()
              ? Colors.amber
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 3.5.w,
        );
      }),
    );
  }
}
