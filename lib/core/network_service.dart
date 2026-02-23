import 'package:dio/dio.dart';
import 'package:taskmanagementflutter/core/base_api.dart';
import 'package:taskmanagementflutter/core/stoarge_service.dart';


class NetworkApiService extends BaseApiService {

  late Dio _dio;

  NetworkApiService() {

    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.31.120:8080',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          final token = await SessionService.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );
  }

  @override
  Future<dynamic> getApi(String url,
      {Map<String, dynamic>? data}) async {

    try {

      final response = await _dio.get(
        url,
        queryParameters: data,
      );

      return _handleResponse(response);

    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> postApi(String url, dynamic data) async {

    try {

      final response = await _dio.post(url, data: data);

      return _handleResponse(response);

    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> putApi(String url, dynamic data) async {

    try {

      final response = await _dio.put(url, data: data);

      return _handleResponse(response);

    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    return response.data;
  }

  dynamic _handleError(DioException e) {

  if (e.response != null && e.response?.data != null) {

    final errorMsg = e.response?.data["error"] ?? "API Error";

    throw Exception(errorMsg);

  } else {
    throw Exception("Network Error");
  }
}
}