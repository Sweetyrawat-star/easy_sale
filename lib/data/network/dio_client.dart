import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/models/api/api.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class DioClient {
  // dio instance
  final Dio _dio;

  // injecting dio instance
  DioClient(this._dio);

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.fromMap(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return ApiResponse.fromMap(e.response?.data);
      } else {
        return new ApiResponse(isSuccess: false, errorMessage: e.message);
      }
    }
  }

  // Post:----------------------------------------------------------------------
  Future<ApiResponse> post(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.fromMap(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return ApiResponse.fromMap(e.response?.data);
      } else {
        return new ApiResponse(isSuccess: false, errorMessage: e.message);
      }
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<dynamic> put(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.fromMap(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return ApiResponse.fromMap(e.response?.data);
      } else {
        return new ApiResponse(isSuccess: false, errorMessage: e.message);
      }
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.fromMap(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return ApiResponse.fromMap(e.response?.data);
      } else {
        return new ApiResponse(isSuccess: false, errorMessage: e.message);
      }
    }
  }

  Future<dynamic> uploadImage(XFile file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file":
      await MultipartFile.fromFile(file.path, filename:fileName),
    });
    try {
      final Response response = await _dio.post(Endpoints.baseDomain+"api/admin/static/upload", data: formData);
      return ApiResponse.fromMap(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        return ApiResponse.fromMap(e.response?.data);
      } else {
        return new ApiResponse(isSuccess: false, errorMessage: e.message);
      }
    }
  }
}
