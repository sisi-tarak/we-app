import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/recommended_tasks_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/task_card_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isHelper =
      true; // Mock user role - can be changed based on user preference
  String _searchQuery = '';
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> _currentUser = {
    "id": 1,
    "name": "Sarah Johnson",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    "location": "Downtown Seattle",
    "role": "helper", // or "poster"
    "rating": 4.8,
    "completedTasks": 23,
  };

  // Mock nearby tasks data
  final List<Map<String, dynamic>> _nearbyTasks = [
    {
      "id": 1,
      "title": "Help with grocery shopping",
      "description":
          "Need someone to pick up groceries from Whole Foods. List will be provided.",
      "category": "Shopping",
      "distance": 0.8,
      "payment": 25.0,
      "urgency": "normal",
      "status": "open",
      "poster": "Michael Chen",
      "location": "Capitol Hill",
      "estimatedTime": "1-2 hours",
    },
    {
      "id": 2,
      "title": "Dog walking service",
      "description":
          "Looking for someone to walk my golden retriever for 30 minutes.",
      "category": "Pet Care",
      "distance": 1.2,
      "payment": 20.0,
      "urgency": "urgent",
      "status": "open",
      "poster": "Emma Wilson",
      "location": "Queen Anne",
      "estimatedTime": "30 minutes",
    },
    {
      "id": 3,
      "title": "Furniture assembly help",
      "description":
          "Need help assembling IKEA furniture. Tools will be provided.",
      "category": "Handyman",
      "distance": 2.1,
      "payment": 40.0,
      "urgency": "normal",
      "status": "open",
      "poster": "David Rodriguez",
      "location": "Ballard",
      "estimatedTime": "2-3 hours",
    },
    {
      "id": 4,
      "title": "House cleaning assistance",
      "description":
          "Looking for help with deep cleaning my apartment before guests arrive.",
      "category": "Cleaning",
      "distance": 1.5,
      "payment": 60.0,
      "urgency": "urgent",
      "status": "open",
      "poster": "Lisa Thompson",
      "location": "Fremont",
      "estimatedTime": "3-4 hours",
    },
    {
      "id": 5,
      "title": "Package delivery pickup",
      "description":
          "Need someone to pick up a package from UPS store and deliver to my office.",
      "category": "Delivery",
      "distance": 0.5,
      "payment": 15.0,
      "urgency": "normal",
      "status": "open",
      "poster": "James Park",
      "location": "South Lake Union",
      "estimatedTime": "1 hour",
    },
  ];

  // Mock recent activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "title": "Grocery shopping completed",
      "description": "Helped Maria with weekly grocery shopping",
      "status": "completed",
      "amount": 30.0,
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "title": "Dog walking in progress",
      "description": "Currently walking Max in Central Park",
      "status": "in_progress",
      "amount": 25.0,
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
    },
    {
      "id": 3,
      "title": "Furniture assembly completed",
      "description": "Successfully assembled IKEA bookshelf for John",
      "status": "completed",
      "amount": 45.0,
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  // Mock recommended tasks
  final List<Map<String, dynamic>> _recommendedTasks = [
    {
      "id": 6,
      "title": "Weekly grocery shopping",
      "description": "Regular weekly grocery shopping for elderly couple.",
      "category": "Shopping",
      "distance": 1.0,
      "payment": 35.0,
      "urgency": "normal",
      "status": "open",
      "poster": "Robert & Mary Johnson",
      "location": "Capitol Hill",
      "estimatedTime": "2 hours",
    },
    {
      "id": 7,
      "title": "Garden maintenance",
      "description":
          "Help with weeding and watering plants in backyard garden.",
      "category": "Handyman",
      "distance": 1.8,
      "payment": 30.0,
      "urgency": "normal",
      "status": "open",
      "poster": "Jennifer Lee",
      "location": "Wallingford",
      "estimatedTime": "1.5 hours",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  List<Map<String, dynamic>> _getFilteredTasks() {
    if (_searchQuery.isEmpty) {
      return _nearbyTasks;
    }

    return _nearbyTasks.where((task) {
      final title = (task['title'] as String).toLowerCase();
      final category = (task['category'] as String).toLowerCase();
      final description = (task['description'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();

      return title.contains(query) ||
          category.contains(query) ||
          description.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'home',
                      color: _tabController.index == 0
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Home',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'search',
                      color: _tabController.index == 1
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Browse',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'message',
                      color: _tabController.index == 2
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Messages',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'person',
                      color: _tabController.index == 3
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Profile',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'account_balance_wallet',
                      color: _tabController.index == 4
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Wallet',
                  ),
                ],
                onTap: (index) {
                  if (index != 0) {
                    // Navigate to other screens when implemented
                    switch (index) {
                      case 1:
                        // Browse screen
                        break;
                      case 2:
                        // Messages screen
                        break;
                      case 3:
                        Navigator.pushNamed(context, '/profile-screen');
                        break;
                      case 4:
                        // Wallet screen
                        break;
                    }
                  }
                },
              ),
            ),

            // Home Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHomeTab(),
                  _buildPlaceholderTab('Browse'),
                  _buildPlaceholderTab('Messages'),
                  _buildPlaceholderTab('Profile'),
                  _buildPlaceholderTab('Wallet'),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button (for task posting)
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/task-posting-screen');
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24,
              ),
              label: Text(
                _isHelper ? 'Post Task' : 'New Task',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHomeTab() {
    final filteredTasks = _getFilteredTasks();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: CustomScrollView(
        slivers: [
          // Greeting Header
          SliverToBoxAdapter(
            child: GreetingHeaderWidget(
              userName: (_currentUser['name'] as String).split(' ').first,
              userAvatar: _currentUser['avatar'] as String,
              currentLocation: _currentUser['location'] as String,
              onNotificationTap: () {
                // Handle notification tap
                _showNotificationBottomSheet();
              },
            ),
          ),

          // Role Toggle (Helper/Poster)
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isHelper = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: _isHelper
                                ? AppTheme.lightTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'I\'m a Helper',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: _isHelper
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isHelper = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: !_isHelper
                                ? AppTheme.lightTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'I Need Help',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: !_isHelper
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.onSurface,
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
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: QuickActionsWidget(
              isHelper: _isHelper,
              onPostTask: () {
                Navigator.pushNamed(context, '/task-posting-screen');
              },
              onFindTasks: () {
                // Navigate to browse tasks
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 3.h)),

          // Search Bar
          SliverToBoxAdapter(
            child: SearchBarWidget(
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              onFilterTap: () {
                _showFilterBottomSheet();
              },
              currentLocation: _currentUser['location'] as String,
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 2.h)),

          // Available Tasks Section
          if (_isHelper && filteredTasks.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Tasks Near You',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all tasks
                      },
                      child: Text('View All'),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = filteredTasks[index];
                  return TaskCardWidget(
                    task: task,
                    isHelper: _isHelper,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/task-detail-screen',
                        arguments: task,
                      );
                    },
                    onSave: () {
                      // Handle save task
                      _showTaskSavedSnackBar();
                    },
                  );
                },
                childCount: filteredTasks.length > 3 ? 3 : filteredTasks.length,
              ),
            ),
          ],

          // Empty state for helpers with no tasks
          if (_isHelper && filteredTasks.isEmpty) ...[
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'search_off',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _searchQuery.isEmpty
                          ? 'No tasks available nearby'
                          : 'No tasks match your search',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _searchQuery.isEmpty
                          ? 'Check back later or expand your search radius'
                          : 'Try different keywords or clear your search',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],

          SliverToBoxAdapter(child: SizedBox(height: 3.h)),

          // Recent Activity
          SliverToBoxAdapter(
            child: RecentActivityWidget(
              activities: _recentActivities,
              isHelper: _isHelper,
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 3.h)),

          // Recommended Tasks
          SliverToBoxAdapter(
            child: RecommendedTasksWidget(
              recommendedTasks: _recommendedTasks,
              isHelper: _isHelper,
              onTaskTap: (task) {
                Navigator.pushNamed(
                  context,
                  '/task-detail-screen',
                  arguments: task,
                );
              },
              onTaskSave: (task) {
                _showTaskSavedSnackBar();
              },
            ),
          ),

          // Bottom padding for FAB
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            '$tabName Coming Soon',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This feature is under development',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'notifications_none',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No new notifications',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'You\'re all caught up!',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Tasks',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: [
                        'All',
                        'Cleaning',
                        'Delivery',
                        'Handyman',
                        'Shopping',
                        'Pet Care'
                      ]
                          .map((category) => FilterChip(
                                label: Text(category),
                                selected: category == 'All',
                                onSelected: (selected) {
                                  // Handle category filter
                                },
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Distance',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text('Within 5 km'),
                    Slider(
                      value: 5.0,
                      min: 1.0,
                      max: 20.0,
                      divisions: 19,
                      label: '5 km',
                      onChanged: (value) {
                        // Handle distance filter
                      },
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Payment Range',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    RangeSlider(
                      values: const RangeValues(10, 100),
                      min: 5,
                      max: 200,
                      divisions: 39,
                      labels: const RangeLabels('\$10', '\$100'),
                      onChanged: (values) {
                        // Handle payment range filter
                      },
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Clear Filters'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskSavedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'bookmark',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Task saved to your favorites'),
          ],
        ),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to saved tasks
          },
        ),
      ),
    );
  }
}
