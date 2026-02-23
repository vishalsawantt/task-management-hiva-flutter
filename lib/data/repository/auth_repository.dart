import '../../core/network_service.dart';

class AuthRepository {

  final api = NetworkApiService();

  Future login(String username, String password) async {
    final res = await api.postApi("/auth/login", {
      "username": username,
      "password": password
    });

    return res["token"];
  }

  Future register(String username, String password) async {
  final res = await api.postApi("/auth/register", {
    "username": username,
    "password": password
  });

  return res["token"];
}
}