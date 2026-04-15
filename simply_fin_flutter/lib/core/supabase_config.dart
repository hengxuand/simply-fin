/// Supabase connection constants.
///
/// For local development these match the default `supabase start` values.
/// Run `supabase status` to confirm them.
/// For production, replace with your project's URL and anon key (or use
/// --dart-define / flutter_dotenv so secrets stay out of source control).
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'http://127.0.0.1:54321';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9'
      '.CRFA0NiK7kyDxFkFm1pqijWqxoXP-7rl8Kl5p4klSqc';
}
