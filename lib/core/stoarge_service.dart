import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {

  static Future saveSession(String username, String token, {String? password}) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("username", username);
    await prefs.setString("token", token);
    await prefs.setBool("isLoggedIn", true);

    //Console logs
    debugPrint("===== SESSION SAVED =====");
    debugPrint("Username: $username");
    debugPrint("Token: $token");

    if (password != null) {
      debugPrint("Password: $password");
    }

    debugPrint("=========================");
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    debugPrint("Fetched Token: $token");

    return token;
  }

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();

    debugPrint("===== LOGOUT =====");
    debugPrint("Clearing session data");

    await prefs.clear();
  }
}