import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/location_section_widget.dart';
import './widgets/payment_section_widget.dart';
import './widgets/poster_profile_widget.dart';
import './widgets/similar_tasks_widget.dart';
import './widgets/task_description_widget.dart';
import './widgets/task_header_widget.dart';
import './widgets/task_image_gallery_widget.dart';
import './widgets/task_requirements_widget.dart';
import './widgets/task_timing_widget.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({Key? key}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool _isTaskAccepted = false;
  bool _isLoading = false;

  // Mock task data
  final Map<String, dynamic> _taskData = {
    "id": 1,
    "title": "Help with Moving Furniture to New Apartment",
    "description":
        """I need assistance moving furniture from my current apartment to a new place. The items include a sofa, dining table, bed frame, and several boxes. The move is within the same city, approximately 5 miles apart. 

I have a moving truck rented, but need 2-3 people to help with loading, unloading, and carrying items up to the 3rd floor (no elevator). The job should take about 3-4 hours total.

Looking for people who are physically fit and have experience with furniture moving. Please bring work gloves if you have them. I'll provide water and snacks during the move.""",
    "category": "Moving & Delivery",
    "urgency": "Medium",
    "amount": 150.0,
    "currency": "\$",
    "paymentType": "Fixed Price",
    "status": "Open",
    "postedTime": DateTime.now().subtract(const Duration(hours: 3)),
    "dueTime": DateTime.now().add(const Duration(days: 2)),
    "images": [
      "https://images.pexels.com/photos/7464230/pexels-photo-7464230.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/4246120/pexels-photo-4246120.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/5025639/pexels-photo-5025639.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    ],
    "poster": {
      "name": "Sarah Johnson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 4.8,
      "completedTasks": 23,
      "isVerified": true
    },
    "location": {
      "address": "1234 Oak Street, Downtown District, Springfield, IL 62701",
      "distance": "2.3 miles",
      "travelTime": "8 mins"
    },
    "requirements": [
      "Physical fitness for heavy lifting",
      "Experience with furniture moving preferred",
      "Ability to work for 3-4 hours continuously",
      "Must be available on weekend"
    ],
    "agePreference": "18-50 years",
    "verificationNeeds": ["ID Verification", "Background Check"],
    "rating": 4.9,
    "isVerified": true
  };

  final List<Map<String, dynamic>> _similarTasks = [
    {
      "id": 2,
      "title": "Apartment Cleaning Service",
      "category": "Cleaning",
      "price": 80.0,
      "distance": "1.5 miles",
      "rating": 4.7,
      "image":
          "https://images.pexels.com/photos/4099468/pexels-photo-4099468.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "id": 3,
      "title": "Grocery Shopping & Delivery",
      "category": "Shopping",
      "price": 45.0,
      "distance": "0.8 miles",
      "rating": 4.9,
      "image":
          "https://images.pexels.com/photos/4199098/pexels-photo-4199098.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    {
      "id": 4,
      "title": "Garden Maintenance Help",
      "category": "Gardening",
      "price": 120.0,
      "distance": "3.2 miles",
      "rating": 4.6,
      "image":
          "https://images.pexels.com/photos/1301856/pexels-photo-1301856.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    }
  ];

  void _handleAcceptTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAcceptTaskBottomSheet(),
    );
  }

  void _handleGetDirections() {
    // In a real app, this would open the native maps app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening directions in maps app...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleViewProfile() {
    Navigator.pushNamed(context, '/profile-screen');
  }

  void _handleShareTask() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task shared successfully!'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _handleReportTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Task'),
        content: Text(
            'Are you sure you want to report this task for inappropriate content?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task reported successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            child: Text('Report'),
          ),
        ],
      ),
    );
  }

  void _handleSimilarTaskTap(Map<String, dynamic> task) {
    // In a real app, this would navigate to the selected task detail
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${task["title"]}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _confirmAcceptTask() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isTaskAccepted = true;
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Task accepted successfully! You can now contact the poster.'),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            title: Text(
              'Task Details',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _handleShareTask,
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'report') {
                    _handleReportTask();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'report',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'report',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('Report Task'),
                      ],
                    ),
                  ),
                ],
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Task Image Gallery
                TaskImageGalleryWidget(
                  images: (_taskData["images"] as List).cast<String>(),
                  onImageTap: () {
                    // In a real app, this would open full-screen gallery
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening image gallery...'),
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                      ),
                    );
                  },
                ),
                SizedBox(height: 3.h),

                // Task Header
                TaskHeaderWidget(
                  title: _taskData["title"] as String,
                  category: _taskData["category"] as String,
                  urgency: _taskData["urgency"] as String,
                  rating: _taskData["rating"] as double,
                  isVerified: _taskData["isVerified"] as bool,
                ),
                SizedBox(height: 3.h),

                // Payment Section
                PaymentSectionWidget(
                  amount: _taskData["amount"] as double,
                  currency: _taskData["currency"] as String,
                  paymentType: _taskData["paymentType"] as String,
                ),
                SizedBox(height: 3.h),

                // Poster Profile
                PosterProfileWidget(
                  name: (_taskData["poster"] as Map<String, dynamic>)["name"]
                      as String,
                  avatar: (_taskData["poster"]
                      as Map<String, dynamic>)["avatar"] as String,
                  rating: (_taskData["poster"]
                      as Map<String, dynamic>)["rating"] as double,
                  completedTasks: (_taskData["poster"]
                      as Map<String, dynamic>)["completedTasks"] as int,
                  isVerified: (_taskData["poster"]
                      as Map<String, dynamic>)["isVerified"] as bool,
                  onTap: _handleViewProfile,
                ),
                SizedBox(height: 3.h),

                // Task Description
                TaskDescriptionWidget(
                  description: _taskData["description"] as String,
                ),
                SizedBox(height: 3.h),

                // Location Section
                LocationSectionWidget(
                  address: (_taskData["location"]
                      as Map<String, dynamic>)["address"] as String,
                  distance: (_taskData["location"]
                      as Map<String, dynamic>)["distance"] as String,
                  travelTime: (_taskData["location"]
                      as Map<String, dynamic>)["travelTime"] as String,
                  onGetDirections: _handleGetDirections,
                ),
                SizedBox(height: 3.h),

                // Task Requirements
                TaskRequirementsWidget(
                  requirements:
                      (_taskData["requirements"] as List).cast<String>(),
                  agePreference: _taskData["agePreference"] as String?,
                  verificationNeeds:
                      (_taskData["verificationNeeds"] as List).cast<String>(),
                ),
                SizedBox(height: 3.h),

                // Task Timing
                TaskTimingWidget(
                  postedTime: _taskData["postedTime"] as DateTime,
                  dueTime: _taskData["dueTime"] as DateTime?,
                  status: _taskData["status"] as String,
                ),
                SizedBox(height: 3.h),

                // Similar Tasks
                SimilarTasksWidget(
                  similarTasks: _similarTasks,
                  onTaskTap: _handleSimilarTaskTap,
                ),
                SizedBox(height: 12.h), // Space for floating button
              ],
            ),
          ),
        ],
      ),

      // Accept Task Button
      floatingActionButton: _isTaskAccepted
          ? Container(
              width: 90.w,
              height: 7.h,
              decoration: BoxDecoration(
                color: AppTheme.successLight,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.successLight.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Task Accepted',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: 90.w,
              height: 7.h,
              child: ElevatedButton(
                onPressed: _handleAcceptTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'handshake',
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Accept Task',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAcceptTaskBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Title
          Text(
            'Accept Task',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Task Summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _taskData["title"] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Text(
                      'Payment: ',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    Text(
                      '${_taskData["currency"] as String}${(_taskData["amount"] as double).toStringAsFixed(0)}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Terms
          Text(
            'By accepting this task, you agree to:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),

          ...[
            'Complete the task as described',
            'Communicate professionally with the poster',
            'Follow WE Community safety guidelines',
            'Payment will be released upon completion'
          ].map((term) => Padding(
                padding: EdgeInsets.only(bottom: 0.8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.3.h),
                      child: CustomIconWidget(
                        iconName: 'check_circle_outline',
                        color: AppTheme.successLight,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        term,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(height: 4.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmAcceptTask,
                  child: _isLoading
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Confirm Accept'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
