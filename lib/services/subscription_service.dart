import 'package:dio/dio.dart';
import '../models/subscription_tier.dart';
import '../models/subscription_status.dart';

/// Service for handling subscription-related API calls
class SubscriptionService {
  final Dio _dio;
  final String baseUrl;

  SubscriptionService({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(),
        baseUrl = baseUrl ?? 'https://api.wecommunity.com/api';

  /// Fetch all available subscription tiers
  Future<List<SubscriptionTier>> fetchSubscriptionTiers() async {
    try {
      // TODO: Replace with actual API call when backend is ready
      // final response = await _dio.get('$baseUrl/subscriptions/tiers');
      // return (response.data as List)
      //     .map((json) => SubscriptionTier.fromJson(json))
      //     .toList();

      // Mock data for now
      await Future.delayed(const Duration(seconds: 1));
      return SubscriptionTier.getDefaultTiers();
    } catch (e) {
      // Fallback to default tiers on error
      return SubscriptionTier.getDefaultTiers();
    }
  }

  /// Select a subscription tier for a user
  Future<SubscriptionStatus> selectSubscriptionTier({
    required String userId,
    required String tierId,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _dio.post(
      //   '$baseUrl/posters/$userId/subscription/select',
      //   data: {'tierId': tierId},
      // );
      // return SubscriptionStatus.fromJson(response.data);

      // Mock response
      await Future.delayed(const Duration(seconds: 1));
      final tiers = SubscriptionTier.getDefaultTiers();
      final selectedTier = tiers.firstWhere((t) => t.id == tierId);

      return SubscriptionStatus(
        userId: userId,
        currentTier: selectedTier,
        monthlyLimit: selectedTier.monthlyLimit,
        usedThisMonth: 0,
        carryoverBalance: 0,
        renewalDate: DateTime.now().add(const Duration(days: 30)),
        autoRenewal: true,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to select subscription tier: $e');
    }
  }

  /// Get current subscription status for a user
  Future<SubscriptionStatus> getSubscriptionStatus(String userId) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _dio.get('$baseUrl/posters/$userId/subscription/status');
      // return SubscriptionStatus.fromJson(response.data);

      // Mock response with Pro tier
      await Future.delayed(const Duration(seconds: 1));
      final tiers = SubscriptionTier.getDefaultTiers();
      final proTier = tiers.firstWhere((t) => t.id == 'pro');

      return SubscriptionStatus(
        userId: userId,
        currentTier: proTier,
        monthlyLimit: proTier.monthlyLimit,
        usedThisMonth: 3500, // Mock usage
        carryoverBalance: 800, // Mock carryover
        renewalDate: DateTime.now().add(const Duration(days: 15)),
        carryoverExpiryDate: DateTime.now().add(const Duration(days: 45)),
        autoRenewal: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to fetch subscription status: $e');
    }
  }

  /// Upgrade subscription to a higher tier
  Future<SubscriptionStatus> upgradeSubscription({
    required String userId,
    required String newTierId,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _dio.post(
      //   '$baseUrl/posters/$userId/subscription/upgrade',
      //   data: {'tierId': newTierId},
      // );
      // return SubscriptionStatus.fromJson(response.data);

      // Mock response
      await Future.delayed(const Duration(seconds: 1));
      final tiers = SubscriptionTier.getDefaultTiers();
      final newTier = tiers.firstWhere((t) => t.id == newTierId);
      final currentStatus = await getSubscriptionStatus(userId);

      return currentStatus.copyWith(
        currentTier: newTier,
        monthlyLimit: newTier.monthlyLimit,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to upgrade subscription: $e');
    }
  }

  /// Get subscription history for a user
  Future<List<Map<String, dynamic>>> getSubscriptionHistory(String userId) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _dio.get('$baseUrl/posters/$userId/subscription/history');
      // return (response.data as List).cast<Map<String, dynamic>>();

      // Mock response
      await Future.delayed(const Duration(seconds: 1));
      return [];
    } catch (e) {
      return [];
    }
  }
}

