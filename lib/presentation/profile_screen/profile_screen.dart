import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../subscription/my_plan_dashboard_screen.dart';
import './widgets/account_actions_widget.dart';
import './widgets/achievement_section_widget.dart';
import './widgets/my_tasks_section_widget.dart';
import './widgets/profile_completion_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_sections_widget.dart';
import './widgets/reviews_section_widget.dart';
import './widgets/settings_list_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 2; // Profile tab active

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "roles": ["Helper", "Poster"],
    "rating": 4.8,
    "reviewCount": 127,
    "completedTasks": 89,
    "points": 1250,
    "leaderboardRank": 15,
    "bio":
        "Passionate helper dedicated to making life easier for my community. Available for various tasks and always ready to lend a helping hand! I specialize in cleaning, delivery, and pet care services.",
    "isIdVerified": true,
    "isBackgroundChecked": false,
    "verificationProgress": 0.75,
    "skills": [
      "Cleaning",
      "Delivery",
      "Pet Care",
      "Handyman",
      "Tutoring",
      "Shopping"
    ],
    "badges": [
      {"id": 1, "name": "Top Helper", "icon": "military_tech"},
      {"id": 2, "name": "Quick Response", "icon": "flash_on"},
      {"id": 3, "name": "5-Star Service", "icon": "star"},
      {"id": 4, "name": "Reliable", "icon": "verified"},
    ],
    "profileCompletion": 0.85,
    "missingItems": ["Phone verification", "Emergency contact"],
  };

  final Map<String, dynamic> taskCounts = {
    "active": 3,
    "completed": 89,
    "saved": 12,
  };

  final List<Map<String, dynamic>> reviews = [
    {
      "id": 1,
      "reviewerName": "Michael Chen",
      "reviewerAvatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
      "rating": 5.0,
      "comment":
          "Sarah was absolutely fantastic! She helped me move my furniture and was incredibly careful with everything. Very professional and friendly. I would definitely hire her again for future tasks.",
      "date": "2 days ago",
    },
    {
      "id": 2,
      "reviewerName": "Emma Rodriguez",
      "reviewerAvatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
      "rating": 5.0,
      "comment":
          "Excellent pet sitting service! Sarah took great care of my dog while I was away. She sent regular updates and photos. Highly recommended!",
      "date": "1 week ago",
    },
    {
      "id": 3,
      "reviewerName": "David Thompson",
      "reviewerAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      "rating": 4.0,
      "comment":
          "Good cleaning service. Sarah was thorough and completed the job on time. Communication could have been better, but overall satisfied with the work.",
      "date": "2 weeks ago",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: _currentTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileHeaderWidget(
                      userData: userData,
                      onEditPhoto: _handleEditPhoto,
                    ),
                    ProfileCompletionWidget(
                      completionPercentage:
                          userData['profileCompletion'] as double? ?? 0.85,
                      missingItems:
                          (userData['missingItems'] as List?)?.cast<String>() ??
                              [],
                      onCompleteProfile: _handleCompleteProfile,
                    ),
                    AchievementSectionWidget(userData: userData),
                    ProfileSectionsWidget(
                      userData: userData,
                      onEditBio: _handleEditBio,
                    ),
                    _buildSubscriptionSection(),
                    SettingsListWidget(
                      onAccountPreferences: _handleAccountPreferences,
                      onNotificationSettings: _handleNotificationSettings,
                      onPaymentMethods: _handlePaymentMethods,
                      onPrivacySettings: _handlePrivacySettings,
                    ),
                    MyTasksSectionWidget(
                      taskCounts: taskCounts,
                      onViewActiveTasks: _handleViewActiveTasks,
                      onViewCompletedTasks: _handleViewCompletedTasks,
                      onViewSavedTasks: _handleViewSavedTasks,
                    ),
                    ReviewsSectionWidget(reviews: reviews),
                    AccountActionsWidget(
                      onEditProfile: _handleEditProfile,
                      onVerificationCenter: _handleVerificationCenter,
                      onHelpSupport: _handleHelpSupport,
                      onLogout: _handleLogout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
          _handleTabNavigation(index);
        },
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentTabIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            text: 'Home',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'add_task',
              color: _currentTabIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            text: 'Post Task',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentTabIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            text: 'Profile',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'task',
              color: _currentTabIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            text: 'Tasks',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'chat',
              color: _currentTabIndex == 4
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            text: 'Chat',
          ),
        ],
        labelColor: AppTheme.lightTheme.primaryColor,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.primaryColor,
        labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.bodySmall,
      ),
    );
  }

  void _handleTabNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/task-posting-screen');
        break;
      case 2:
        // Current screen - Profile
        break;
      case 3:
        Navigator.pushNamed(context, '/task-detail-screen');
        break;
      case 4:
        // Navigate to chat screen (not implemented)
        break;
    }
  }

  void _handleEditPhoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Profile Photo',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption(
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle camera capture
                  },
                ),
                _buildPhotoOption(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle gallery selection
                  },
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.primaryColor,
              size: 7.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _handleCompleteProfile() {
    // Navigate to profile completion flow
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Redirecting to profile completion...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleEditBio() {
    // Navigate to bio editing screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening bio editor...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleAccountPreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening account preferences...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening notification settings...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handlePaymentMethods() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening payment methods...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handlePrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening privacy settings...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleViewActiveTasks() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Viewing active tasks...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleViewCompletedTasks() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Viewing completed tasks...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleViewSavedTasks() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Viewing saved tasks...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _handleEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening profile editor...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleVerificationCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening verification center...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleHelpSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening help & support...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _handleMySubscription() {
    // Generate a mock user ID (in production, this would come from user data)
    final userId = (userData['id'] ?? 1).toString();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPlanDashboardScreen(userId: userId),
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: 'subscriptions',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
        ),
        title: Text(
          'My Subscription',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'View and manage your subscription plan',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 4.w,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
        onTap: _handleMySubscription,
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login-screen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Logout',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
