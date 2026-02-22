/// Supabase project credentials.
///
/// Replace these placeholder values with your actual Supabase project URL
/// and anonymous/public API key. You can find them in your Supabase dashboard
/// under Settings > API.
///
/// Never commit real service-role keys to version control.
abstract final class SupabaseConfig {
  /// Supabase project URL.
  static const String url = 'https://agbkabivksenuosjcard.supabase.co';

  /// Anon / public API key — safe to ship in the client.
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFnYmthYml2a3NlbnVvc2pjYXJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE3MjIzNDAsImV4cCI6MjA4NzI5ODM0MH0.1vKpZOTKTmfXO1VmqLNSuatf6c4UwFkiCha0GpFLaUM';
}
