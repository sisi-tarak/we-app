/// Subscription tier model representing the three subscription plans
class SubscriptionTier {
  final String id;
  final String name;
  final double price;
  final int monthlyLimit; // in rupees
  final double commissionRate; // 0.06 for 6%
  final bool verifiedBadge;
  final String supportLevel; // Standard, 24-hour, Priority
  final bool advancedAnalytics;
  final int carryoverMonths; // Up to 3 months
  final String bgColor; // Hex color or gradient
  final String description;
  final bool isRecommended;

  SubscriptionTier({
    required this.id,
    required this.name,
    required this.price,
    required this.monthlyLimit,
    required this.commissionRate,
    required this.verifiedBadge,
    required this.supportLevel,
    required this.advancedAnalytics,
    required this.carryoverMonths,
    required this.bgColor,
    required this.description,
    this.isRecommended = false,
  });

  factory SubscriptionTier.fromJson(Map<String, dynamic> json) {
    return SubscriptionTier(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      monthlyLimit: json['monthlyLimit'] as int,
      commissionRate: (json['commissionRate'] as num).toDouble(),
      verifiedBadge: json['verifiedBadge'] as bool,
      supportLevel: json['supportLevel'] as String,
      advancedAnalytics: json['advancedAnalytics'] as bool,
      carryoverMonths: json['carryoverMonths'] as int,
      bgColor: json['bgColor'] as String,
      description: json['description'] as String,
      isRecommended: json['isRecommended'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'monthlyLimit': monthlyLimit,
      'commissionRate': commissionRate,
      'verifiedBadge': verifiedBadge,
      'supportLevel': supportLevel,
      'advancedAnalytics': advancedAnalytics,
      'carryoverMonths': carryoverMonths,
      'bgColor': bgColor,
      'description': description,
      'isRecommended': isRecommended,
    };
  }

  /// Get static tier definitions
  static List<SubscriptionTier> getDefaultTiers() {
    return [
      SubscriptionTier(
        id: 'starter',
        name: 'Starter',
        price: 299.0,
        monthlyLimit: 5000,
        commissionRate: 0.06,
        verifiedBadge: false,
        supportLevel: 'Standard',
        advancedAnalytics: false,
        carryoverMonths: 3,
        bgColor: '#F8FAFB',
        description: 'Perfect for occasional task posting',
        isRecommended: false,
      ),
      SubscriptionTier(
        id: 'pro',
        name: 'Pro',
        price: 599.0,
        monthlyLimit: 15000,
        commissionRate: 0.06,
        verifiedBadge: true,
        supportLevel: '24-hour',
        advancedAnalytics: true,
        carryoverMonths: 3,
        bgColor: 'gradient', // Special gradient for Pro
        description: 'Best value for regular task posters',
        isRecommended: true,
      ),
      SubscriptionTier(
        id: 'premium',
        name: 'Premium',
        price: 799.0,
        monthlyLimit: 30000,
        commissionRate: 0.06,
        verifiedBadge: true,
        supportLevel: 'Priority',
        advancedAnalytics: true,
        carryoverMonths: 3,
        bgColor: '#1B5E8F',
        description: 'For high-volume task posting',
        isRecommended: false,
      ),
    ];
  }
}

