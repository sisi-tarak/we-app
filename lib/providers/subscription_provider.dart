import 'package:flutter/foundation.dart';
import '../models/subscription_tier.dart';
import '../models/subscription_status.dart';
import '../services/subscription_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State management for subscription functionality
class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService;

  List<SubscriptionTier> _tiers = [];
  SubscriptionStatus? _subscriptionStatus;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastFetched;

  SubscriptionProvider({SubscriptionService? subscriptionService})
      : _subscriptionService = subscriptionService ?? SubscriptionService();

  // Getters
  List<SubscriptionTier> get tiers => _tiers;
  SubscriptionStatus? get subscriptionStatus => _subscriptionStatus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasSubscription => _subscriptionStatus != null;

  /// Fetch all available subscription tiers
  Future<void> fetchSubscriptionTiers() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _tiers = await _subscriptionService.fetchSubscriptionTiers();
      await _cacheTiers();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Fetch subscription status for a user
  Future<void> fetchSubscriptionStatus(String userId) async {
    // Check cache first (5 minute cache)
    if (_lastFetched != null &&
        DateTime.now().difference(_lastFetched!).inMinutes < 5) {
      return;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      _subscriptionStatus = await _subscriptionService.getSubscriptionStatus(userId);
      _lastFetched = DateTime.now();
      await _cacheStatus();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Select a subscription tier
  Future<bool> selectSubscriptionTier({
    required String userId,
    required String tierId,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _subscriptionStatus = await _subscriptionService.selectSubscriptionTier(
        userId: userId,
        tierId: tierId,
      );
      _lastFetched = DateTime.now();
      await _cacheStatus();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Upgrade subscription to a higher tier
  Future<bool> upgradeSubscription({
    required String userId,
    required String newTierId,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _subscriptionStatus = await _subscriptionService.upgradeSubscription(
        userId: userId,
        newTierId: newTierId,
      );
      _lastFetched = DateTime.now();
      await _cacheStatus();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Calculate available limit
  int calculateAvailableLimit() {
    if (_subscriptionStatus == null) return 0;
    return _subscriptionStatus!.availableLimit;
  }

  /// Check if task cost exceeds limit
  bool isLimitExceeded(int taskCost) {
    if (_subscriptionStatus == null) return true;
    return _subscriptionStatus!.isLimitExceeded(taskCost);
  }

  /// Calculate commission for over-limit task
  double calculateCommission(int taskCost) {
    if (_subscriptionStatus == null) return taskCost * 0.06;
    return _subscriptionStatus!.calculateCommission(taskCost);
  }

  /// Get next tier for upgrade
  SubscriptionTier? getNextTier() {
    if (_subscriptionStatus == null || _tiers.isEmpty) return null;
    
    final currentTierIndex = _tiers.indexWhere(
      (t) => t.id == _subscriptionStatus!.currentTier.id,
    );
    
    if (currentTierIndex == -1 || currentTierIndex >= _tiers.length - 1) {
      return null;
    }
    
    return _tiers[currentTierIndex + 1];
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Refresh subscription status
  Future<void> refreshSubscriptionStatus(String userId) async {
    _lastFetched = null; // Force refresh
    await fetchSubscriptionStatus(userId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Cache tiers to SharedPreferences
  Future<void> _cacheTiers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Store tier IDs as simple cache indicator
      await prefs.setString('subscription_tiers_cached', 'true');
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Cache subscription status to SharedPreferences
  Future<void> _cacheStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_subscriptionStatus != null) {
        // Store basic status info
        await prefs.setString('subscription_tier_id', _subscriptionStatus!.currentTier.id);
        await prefs.setInt('subscription_limit', _subscriptionStatus!.monthlyLimit);
        await prefs.setInt('subscription_used', _subscriptionStatus!.usedThisMonth);
        await prefs.setInt('subscription_carryover', _subscriptionStatus!.carryoverBalance);
      }
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Load cached subscription status
  Future<void> loadCachedStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tierId = prefs.getString('subscription_tier_id');
      
      if (tierId != null) {
        // Load tiers first
        await fetchSubscriptionTiers();
        
        // Find matching tier
        final tier = _tiers.firstWhere(
          (t) => t.id == tierId,
          orElse: () => _tiers.isNotEmpty ? _tiers[0] : SubscriptionTier.getDefaultTiers()[0],
        );
        
        _subscriptionStatus = SubscriptionStatus(
          userId: 'cached',
          currentTier: tier,
          monthlyLimit: prefs.getInt('subscription_limit') ?? tier.monthlyLimit,
          usedThisMonth: prefs.getInt('subscription_used') ?? 0,
          carryoverBalance: prefs.getInt('subscription_carryover') ?? 0,
          renewalDate: DateTime.now().add(const Duration(days: 30)),
          autoRenewal: true,
          createdAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      // Ignore cache load errors
    }
  }
}

