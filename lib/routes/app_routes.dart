import 'package:flutter/material.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/subscription/my_plan_dashboard_screen.dart';
import '../presentation/subscription/subscription_selection_screen.dart';
import '../presentation/task_detail_screen/task_detail_screen.dart';
import '../presentation/task_posting_screen/task_posting_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String homeDashboard = '/home-dashboard';
  static const String login = '/login-screen';
  static const String profile = '/profile-screen';
  static const String subscriptionSelection = '/subscription-selection';
  static const String myPlanDashboard = '/my-plan-dashboard';
  static const String taskDetail = '/task-detail-screen';
  static const String taskPosting = '/task-posting-screen';
  static const String registration = '/registration-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    login: (context) => const LoginScreen(),
    profile: (context) => const ProfileScreen(),
    subscriptionSelection: (context) {
      // Mock user ID - in production, get from route arguments or auth context
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return SubscriptionSelectionScreen(
        userId: args?['userId'] ?? '1',
        selectedRole: args?['selectedRole'],
      );
    },
    myPlanDashboard: (context) {
      // Mock user ID - in production, get from route arguments or auth context
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return MyPlanDashboardScreen(
        userId: args?['userId'] ?? '1',
      );
    },
    taskDetail: (context) => const TaskDetailScreen(),
    taskPosting: (context) => const TaskPostingScreen(),
    registration: (context) => const RegistrationScreen(),
    // TODO: Add your other routes here
  };
}
