import 'package:shared_preferences/shared_preferences.dart';

class SyncService {

  static Future setLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("lastSync", DateTime.now().toIso8601String());
  }

  static Future<String?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("lastSync");
  }
}