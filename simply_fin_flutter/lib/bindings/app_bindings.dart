import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Central GetX dependency bindings for the app.
///
/// Register all controllers and services here so they are lazily created
/// and automatically disposed when no longer needed.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
