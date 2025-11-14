import 'subscription_tier.dart';

/// Subscription status model representing current user subscription
class SubscriptionStatus {
  final String userId;
  final SubscriptionTier currentTier;
  final int monthlyLimit;
  final int usedThisMonth;
  final int carryoverBalance;
  final DateTime renewalDate;
  final DateTime? carryoverExpiryDate;
  final bool autoRenewal;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  SubscriptionStatus({
    required this.userId,
    required this.currentTier,
    required this.monthlyLimit,
    required this.usedThisMonth,
    required this.carryoverBalance,
    required this.renewalDate,
    this.carryoverExpiryDate,
    required this.autoRenewal,
    required this.createdAt,
    this.lastUpdated,
  });

  /// Calculate available limit (monthly + carryover - used)
  int get availableLimit => monthlyLimit + carryoverBalance - usedThisMonth;

  /// Calculate usage percentage
  double get usagePercentage => monthlyLimit > 0 
      ? (usedThisMonth / monthlyLimit) * 100 
      : 0.0;

  /// Get usage status color threshold
  String get usageStatusColor {
    if (usagePercentage < 50) return '#4CAF50'; // Green
    if (usagePercentage < 80) return '#FFC107'; // Yellow
    return '#F44336'; // Red
  }

  /// Check if limit is exceeded
  bool isLimitExceeded(int taskCost) => availableLimit < taskCost;

  /// Calculate commission for over-limit task
  double calculateCommission(int taskCost) => taskCost * 0.06;

  /// Calculate total cost with commission
  double calculateTotalWithCommission(int taskCost) => 
      taskCost + calculateCommission(taskCost);

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      userId: json['userId'] as String,
      currentTier: SubscriptionTier.fromJson(json['currentTier'] as Map<String, dynamic>),
      monthlyLimit: json['monthlyLimit'] as int,
      usedThisMonth: json['usedThisMonth'] as int,
      carryoverBalance: json['carryoverBalance'] as int,
      renewalDate: DateTime.parse(json['renewalDate'] as String),
      carryoverExpiryDate: json['carryoverExpiryDate'] != null
          ? DateTime.parse(json['carryoverExpiryDate'] as String)
          : null,
      autoRenewal: json['autoRenewal'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentTier': currentTier.toJson(),
      'monthlyLimit': monthlyLimit,
      'usedThisMonth': usedThisMonth,
      'carryoverBalance': carryoverBalance,
      'renewalDate': renewalDate.toIso8601String(),
      'carryoverExpiryDate': carryoverExpiryDate?.toIso8601String(),
      'autoRenewal': autoRenewal,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  SubscriptionStatus copyWith({
    String? userId,
    SubscriptionTier? currentTier,
    int? monthlyLimit,
    int? usedThisMonth,
    int? carryoverBalance,
    DateTime? renewalDate,
    DateTime? carryoverExpiryDate,
    bool? autoRenewal,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return SubscriptionStatus(
      userId: userId ?? this.userId,
      currentTier: currentTier ?? this.currentTier,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      usedThisMonth: usedThisMonth ?? this.usedThisMonth,
      carryoverBalance: carryoverBalance ?? this.carryoverBalance,
      renewalDate: renewalDate ?? this.renewalDate,
      carryoverExpiryDate: carryoverExpiryDate ?? this.carryoverExpiryDate,
      autoRenewal: autoRenewal ?? this.autoRenewal,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

