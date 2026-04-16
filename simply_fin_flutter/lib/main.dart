import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bindings/app_bindings.dart';
import 'core/supabase_config.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SimplyFin',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      theme: AppTheme.light,
      home: Supabase.instance.client.auth.currentSession != null
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
