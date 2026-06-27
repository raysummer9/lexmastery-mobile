import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:lexmastery_mobile/core/environment/app_environment.dart';
import 'package:lexmastery_mobile/core/errors/app_failure.dart';

class ApiClient {
  ApiClient({
    required EnvironmentConfig environment,
    required Logger logger,
    String? accessToken,
  })  : _logger = logger,
        _accessToken = accessToken,
        _dio = Dio(
          BaseOptions(
            baseUrl: environment.apiBaseUrl,
            connectTimeout: const Duration(seconds: 12),
            sendTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            responseType: ResponseType.json,
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          options.headers['Content-Type'] = 'application/json';
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
              'HTTP ${response.statusCode}: ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.w(
            'HTTP ERROR ${error.response?.statusCode}: ${error.requestOptions.path}',
          );
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final Logger _logger;
  String? _accessToken;

  void updateAccessToken(String? token) {
    _accessToken = token;
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<dynamic>(path, queryParameters: queryParameters);
    } on DioException catch (error) {
      throw _mapDioFailure(error);
    }
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (error) {
      throw _mapDioFailure(error);
    }
  }

  AppFailure _mapDioFailure(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return const AppFailure(
        type: AppFailureType.authentication,
        message: 'Authentication failed. Please sign in again.',
      );
    }
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return const AppFailure(
        type: AppFailureType.validation,
        message: 'Request was invalid. Please check your input.',
      );
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const AppFailure(
        type: AppFailureType.network,
        message: 'Unable to connect. Check your internet connection.',
      );
    }
    return const AppFailure(
      type: AppFailureType.unknown,
      message: 'Something went wrong. Please try again.',
    );
  }
}
