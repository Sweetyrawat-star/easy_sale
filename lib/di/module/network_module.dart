import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../utils/shared/nav_service.dart';

abstract class NetworkModule {
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.
  static Dio provideDio(SharedPreferenceHelper sharedPrefHelper) {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options,
              RequestInterceptorHandler handler) async {
            // getting token
            var token = await sharedPrefHelper.authToken;

            if (token != null) {
              options.headers.putIfAbsent('Authorization', () => "Bearer " + token);
            } else {
              print('Auth token is null');
            }

            return handler.next(options);
          },
          onError: (DioError e, ErrorInterceptorHandler handler) async {
            if (e.response != null && e.response?.statusCode == 401) {
              GetIt.instance<UserStore>().clearUserData();
              GetIt.instance<NavigationService>().navigateTo(Routes.login);
            } else {
              print(e);
              handler.next(e);
            }
          }
        ),
      );

    return dio;
  }
}
