import 'package:dio/dio.dart';
import 'error/error_exception.dart';

class DioClient {
  final Dio _dio;
  DioClient._internal(this._dio);

  static final DioClient instance = DioClient._internal(
    Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw NetworkException(e.message ?? "Something went Wrong!");
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw NetworkException(e.message ?? "Something went Wrong!");
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw NetworkException(e.message ?? "Something went Wrong!");
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await _dio.delete(path, data: data);
    } on DioException catch (e) {
      throw NetworkException(e.message ?? "Something went Wrong!");
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
