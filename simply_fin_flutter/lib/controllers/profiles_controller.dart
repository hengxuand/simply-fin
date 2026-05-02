import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_logger.dart';

class ProfilesController extends GetxController {
  final _supabase = Supabase.instance.client;

  final profile = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;

  StreamSubscription<AuthState>? _authSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? _profileStreamSubscription;
  String? _currentUserId;

  @override
  void onInit() {
    super.onInit();

    // Hydrate controller state when app starts with an existing session.
    _syncWithSession();

    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session?.user != null) {
        _handleSignedIn(session!.user.id);
        return;
      }
      _handleSignedOut();
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _disposeRealtime();
    super.onClose();
  }

  Future<void> refreshProfile() async {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }

    isLoading.value = true;
    try {
      final row = await _supabase
          .from('profiles')
          .select('id, username, full_name, updated_at')
          .eq('id', userId)
          .maybeSingle();

      profile.value = row == null ? null : Map<String, dynamic>.from(row);
      appLogger.d('[Profile] Refreshed profile for user $userId.');
    } catch (e, st) {
      appLogger.e(
        '[Profile] Failed to refresh profile.',
        error: e,
        stackTrace: st,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearProfile() {
    profile.value = null;
  }

  Future<void> _syncWithSession() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _handleSignedOut();
      return;
    }
    await _handleSignedIn(user.id);
  }

  Future<void> _handleSignedIn(String userId) async {
    if (_currentUserId == userId && _profileStreamSubscription != null) {
      await refreshProfile();
      return;
    }

    _currentUserId = userId;
    await _disposeRealtime();
    await refreshProfile();
    _subscribeToProfileRealtime(userId);
  }

  void _handleSignedOut() {
    _currentUserId = null;
    _disposeRealtime();
    clearProfile();
    appLogger.i('[Profile] Cleared profile after sign-out.');
  }

  void _subscribeToProfileRealtime(String userId) {
    _profileStreamSubscription = _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .listen(
          (rows) {
            if (rows.isEmpty) {
              clearProfile();
              appLogger.w('[Profile] Profile row deleted for user $userId.');
              return;
            }

            profile.value = Map<String, dynamic>.from(rows.first);
            appLogger.d('[Profile] Realtime update received for user $userId.');
          },
          onError: (Object error, StackTrace stackTrace) {
            appLogger.e(
              '[Profile] Realtime stream error for user $userId.',
              error: error,
              stackTrace: stackTrace,
            );
          },
        );

    appLogger.i('[Profile] Realtime subscription active for user $userId.');
  }

  Future<void> _disposeRealtime() async {
    final subscription = _profileStreamSubscription;
    _profileStreamSubscription = null;
    if (subscription == null) {
      return;
    }

    try {
      await subscription.cancel();
    } catch (e, st) {
      appLogger.e(
        '[Profile] Failed to cancel realtime stream.',
        error: e,
        stackTrace: st,
      );
    }
  }
}
