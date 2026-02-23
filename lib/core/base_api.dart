abstract class BaseApiService {

  Future<dynamic> getApi(String url, {Map<String, dynamic>? data});

  Future<dynamic> postApi(String url, dynamic data);

  Future<dynamic> putApi(String url, dynamic data);
}