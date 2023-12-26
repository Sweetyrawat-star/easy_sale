
import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/network/apis/brands/brand_api.dart';
import 'package:boilerplate/data/network/apis/cart/cart_api.dart';
import 'package:boilerplate/data/network/apis/categories/category_api.dart';
import 'package:boilerplate/data/network/apis/notes/note_api.dart';
import 'package:boilerplate/data/network/apis/order/order_api.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/network/apis/products/product_api.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/di/module/local_module.dart';
import 'package:boilerplate/di/module/network_module.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/store/store_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/apis/areas/area_api.dart';
import '../../data/network/apis/feedbacks/feedback_api.dart';
import '../../data/network/apis/kpis/kpi_api.dart';
import '../../data/network/apis/ratings/rating_api.dart';
import '../../data/network/apis/stores/store_api.dart';
import '../../data/network/apis/users/user_api.dart';
import '../../data/network/apis/visit/visit_api.dart';
import '../../stores/feedback/feedback_store.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // factories:-----------------------------------------------------------------
  getIt.registerFactory(() => ErrorStore());
  getIt.registerFactory(() => FormStore());

  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<Database>(() => LocalModule.provideDatabase());
  getIt.registerSingletonAsync<SharedPreferences>(() => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(RestClient());
  getIt.registerSingleton(NavigationService());

  // api's:---------------------------------------------------------------------
  getIt.registerSingleton(PostApi(getIt<DioClient>()));
  getIt.registerSingleton(UserApi(getIt<DioClient>()));
  getIt.registerSingleton(FeedbackApi(getIt<DioClient>()));
  getIt.registerSingleton(StoreApi(getIt<DioClient>()));
  getIt.registerSingleton(NoteApi(getIt<DioClient>()));
  getIt.registerSingleton(AreaApi(getIt<DioClient>()));
  getIt.registerSingleton(RatingApi(getIt<DioClient>()));
  getIt.registerSingleton(CategoryApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(BrandApi(getIt<DioClient>()));
  getIt.registerSingleton(ProductApi(getIt<DioClient>()));
  getIt.registerSingleton(CartApi(getIt<DioClient>()));
  getIt.registerSingleton(OrderApi(getIt<DioClient>()));
  getIt.registerSingleton(VisitApi(getIt<DioClient>()));
  getIt.registerSingleton(KpiApi(getIt<DioClient>()));

  // data sources
  getIt.registerSingleton(PostDataSource(await getIt.getAsync<Database>()));

  // repository:----------------------------------------------------------------
  getIt.registerSingleton(Repository(
    getIt<PostApi>(),
    getIt<SharedPreferenceHelper>(),
    getIt<PostDataSource>(),
    getIt<UserApi>(),
    getIt<StoreApi>(),
    getIt<NoteApi>(),
    getIt<AreaApi>(),
    getIt<RatingApi>(),
    getIt<CategoryApi>(),
    getIt<BrandApi>(),
    getIt<ProductApi>(),
    getIt<CartApi>(),
    getIt<OrderApi>(),
    getIt<VisitApi>(),
    getIt<KpiApi>(),
  ));

  // stores:--------------------------------------------------------------------
  getIt.registerSingleton(LanguageStore(getIt<Repository>()));
  getIt.registerSingleton(PostStore(getIt<Repository>()));
  getIt.registerSingleton(ThemeStore(getIt<Repository>()));
  getIt.registerSingleton(UserStore(getIt<Repository>()));
  getIt.registerSingleton(FeedbackStore(getIt<Repository>()));
  getIt.registerSingleton(StoreStore(getIt<Repository>()));
}
