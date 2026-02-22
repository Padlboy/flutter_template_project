/// Supabase project credentials.
///
/// Replace the placeholder values with your actual Supabase project URL
/// and anonymous/public API key from the Supabase dashboard: Settings > API.
///
/// Tip: use a `.env` file or --dart-define flags to inject these at build time
/// so you never commit real secrets to version control.
abstract final class SupabaseConfig {
  /// Supabase project URL.
  /// Example: 'https://xyzcompany.supabase.co'
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://YOUR_PROJECT_ID.supabase.co',
  );

  /// Anon / public API key — safe to ship in the client.
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_ANON_KEY',
  );
}
