import 'package:supabase_flutter/supabase_flutter.dart';

/// Wraps Supabase auth operations for use in the app.
class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  /// The currently signed-in user, or null if not authenticated.
  User? get currentUser => _client.auth.currentUser;

  /// Stream of auth state changes.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Signs in with email and password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) =>
      _client.auth.signInWithPassword(email: email, password: password);

  /// Creates a new account.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) =>
      _client.auth.signUp(email: email, password: password);

  /// Signs out the current user.
  Future<void> signOut() => _client.auth.signOut();
}
