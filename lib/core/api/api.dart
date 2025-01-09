// ignore_for_file: annotate_overrides, overridden_fields, unnecessary_overrides
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:todo_tasky/core/constants/app_urls.dart';

class API {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: AppUrl.baseURL,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    responseType: ResponseType.json,
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ))
    ..interceptors.addAll([
      CustomDioLogger(
        requestHeader: true,
        requestBody: true,
        error: false,
      )
    ]);

  //! GET METHOD
  Future<Response> get(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      options = options ?? Options();
      if (headers != null) {
        options = options.copyWith(headers: headers);
      }
      final Response response = await dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //! POST METHOD
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      options = options ?? Options();
      if (headers != null) {
        options = options.copyWith(headers: headers);
      }
      final Response response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //! PUT METHOD
  Future<Response> put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      options = options ?? Options();
      if (headers != null) {
        options = options.copyWith(headers: headers);
      }
      final Response response = await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //! DELETE METHOD
  Future<Response> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      options = options ?? Options();
      if (headers != null) {
        options = options.copyWith(headers: headers);
      }
      final Response response = await dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

/// This interceptor is used to show request and response logs

class CustomDioLogger extends PrettyDioLogger {
  final bool requestHeader, requestBody, responseBody, error, compact;
  final int maxWidth;
  CustomDioLogger({
    this.requestHeader = false,
    this.requestBody = false,
    this.responseBody = true,
    this.error = true,
    this.compact = true,
    this.maxWidth = 90,
  }) : super(
          requestHeader: requestHeader,
          requestBody: requestBody,
          responseBody: responseBody,
          error: error,
          compact: compact,
          maxWidth: maxWidth,
        );

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      logPrint('🔴 Response Data: ${err.response?.data}');
      logPrint('🔴 Status Code: ${err.response?.statusCode}');
      logPrint('🔴 Headers: ${err.response?.headers}');
    } else if (err.message != null) {
      logPrint('🔴 Error1: ${err.message}');
    } else {
      logPrint('🔴 Error2: ${err.error}');
    }
    super.onError(err, handler);
  }
}
