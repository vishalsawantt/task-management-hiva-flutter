import 'package:get/get.dart';
import '../data/repository/auth_repository.dart';
import '../core/stoarge_service.dart';
import '../utils/utils.dart';

class AuthController extends GetxController {

  final repo = AuthRepository();
  RxBool isLoading = false.obs;

  //LOGIN
  Future login(String username, String password) async {
  final user = username.trim();
  final pass = password.trim();
  if (user.isEmpty || pass.isEmpty) {
    Utils.toastMesage("Username and Password cannot be empty");
    return;
  }
  try {
    final token = await repo.login(user, pass);
    await SessionService.saveSession(user, token);
    Utils.toastMesage("Login Successful");
    Get.offAllNamed("/tasks");
  } catch (e) {
    Utils.snackBarError("Login Failed", "Invalid credentials");
  }
}

  //REGISTER
  Future register(String username, String password) async {
  try {
    isLoading.value = true;
    if (username.isEmpty || password.isEmpty) {
      Utils.snackBarError("Error", "All fields required");
      return;
    }

    final token = await repo.register(username, password);

    if (token == null || token.isEmpty) {
      Utils.snackBarError("Error", "Registration failed");
      return;
    }

    await SessionService.saveSession(username, token);
    Utils.toastMesage("Account created successfully");
    Get.offAllNamed("/tasks");

  } catch (e) {
    Utils.snackBarError("Error", e.toString());

  } finally {
    //ALWAYS reset loading
    isLoading.value = false;
  }
}
  //LOGOUT
  Future logout() async {
    await SessionService.logout();
    Utils.toastMesage("Logged out");
    Get.offAllNamed("/login");
  }
}