import 'dart:async';

import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/network/apis/areas/area_api.dart';
import 'package:boilerplate/data/network/apis/brands/brand_api.dart';
import 'package:boilerplate/data/network/apis/cart/cart_api.dart';
import 'package:boilerplate/data/network/apis/notes/note_api.dart';
import 'package:boilerplate/data/network/apis/order/order_api.dart';
import 'package:boilerplate/data/network/apis/products/product_api.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/cart/cart.dart';
import 'package:boilerplate/models/job/job.dart';
import 'package:boilerplate/models/note/note.dart';
import 'package:boilerplate/models/order/order.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/rating/rating.dart';
import 'package:boilerplate/models/routing/routing.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/models/variant/variant_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sembast/sembast.dart';

import '../models/api/api.dart';
import '../models/brand/brand.dart';
import '../models/brand/brand_list.dart';
import '../models/product/product.dart';
import '../models/rating/rating_list.dart';
import '../models/routing/routing_detail.dart';
import '../models/store/store.dart';
import '../models/store/store_list.dart';
import '../models/variant/variant.dart';
import 'local/constants/db_constants.dart';
import 'network/apis/categories/category_api.dart';
import 'network/apis/kpis/kpi_api.dart';
import 'network/apis/posts/post_api.dart';
import 'network/apis/ratings/rating_api.dart';
import 'network/apis/stores/store_api.dart';
import 'network/apis/users/user_api.dart';
import 'network/apis/visit/visit_api.dart';

class Repository {
  // data source object
  final PostDataSource _postDataSource;

  // api objects
  final PostApi _postApi;
  final UserApi _userApi;
  final StoreApi _storeApi;
  final NoteApi _noteApi;
  final AreaApi _areaApi;
  final RatingApi _ratingApi;
  final CategoryApi _categoryApi;
  final BrandApi _brandApi;
  final ProductApi _productApi;
  final CartApi _cartApi;
  final OrderApi _orderApi;
  final VisitApi _visitApi;
  final KpiApi _kpiApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(
    this._postApi,
    this._sharedPrefsHelper,
    this._postDataSource,
    this._userApi,
    this._storeApi,
    this._noteApi,
    this._areaApi,
    this._ratingApi,
    this._categoryApi,
    this._brandApi,
    this._productApi,
    this._cartApi,
    this._orderApi,
    this._visitApi,
    this._kpiApi,
  );

  Future<Map<String, num>> getKpis() async {
    var futures = await Future.wait([
      this._kpiApi.getKpiOverallVariant(),
      this._kpiApi.getKpiOverallOrder("created,delivered,verified,shipped,canceled,returned"),
      this._kpiApi.getKpiOverallOrder("created,verified,shipped"),
      this._kpiApi.getKpiOverallOrder("delivered"),
    ]);

    var tmp = futures[1] as Map<String, num>;
    tmp["totalSKU"] = futures[0] as int;

    var tmp1 = futures[2] as Map<String, num>;
    tmp["totalPriceWaiting"] = tmp1["totalPrice"]!;

    var tmp2 = futures[3] as Map<String, num>;
    tmp["totalPriceDelivered"] = tmp2["totalPrice"]!;
    return tmp;
  }

  // Post: ---------------------------------------------------------------------
  Future<PostList> getPosts() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getPosts().then((postsList) {
      postsList.posts?.forEach((post) {
        _postDataSource.insert(post);
      });

      return postsList;
    }).catchError((error) => throw error);
  }

  Future<Cart> getCart() async {
    return await _cartApi.getCart().then((cart) {
      return cart;
    }).catchError((error) => throw error);
  }

  Future<Cart> updateCart(Cart cart) async {
    return await _cartApi.updateCart(cart).then((cart) {
      return cart;
    }).catchError((error) => throw error);
  }

  Future<ApiResponse> uploadImage(XFile file) => _userApi.uploadImage(file);

  Future<RatingList> getFeedbacks(Map<String, dynamic> params) async {
    return await _ratingApi
        .getRatings(params)
        .then((fbList) => fbList)
        .catchError((error) => throw error);
  }

  Future<ProductVariantList> getProductVariants(Map<String, dynamic> params) async {
    return await _productApi
        .getProductVariants(params)
        .then((fbList) => fbList)
        .catchError((error) => throw error);
  }

  Future<ProductVariant> getProductVariant(String id) async {
    return await _productApi
        .getProductVariant(id)
        .then((fbList) => fbList)
        .catchError((error) => throw error);
  }

  Future<Product> getProduct(String id) async {
    return await _productApi
        .getProduct(id)
        .then((fbList) => fbList)
        .catchError((error) => throw error);
  }

  Future<List<Rating>> getRatings(Map<String, dynamic> params) async {
    return await _ratingApi
        .getRatings(params)
        .then((fbList) => fbList.ratings)
        .catchError((error) => throw error);
  }

  Future<StoreList> getStores(Map<String, dynamic> params) async {
    return await _storeApi
        .getStores(params)
        .then((fbList) => fbList)
        .catchError((error) => throw error);
  }

  Future<Store> getStore(String id) async {
    return await _storeApi
        .getStore(id)
        .then((fbList) => fbList)
        .catchError((error) => throw error);
  }

  Future<List<Store>> getStores2(Map<String, dynamic> params) async {
    return await _storeApi
        .getStores(params)
        .then((fbList) => fbList.stores)
        .catchError((error) => throw error);
  }

  Future<Store> createStore(Store store) async {
    return await _storeApi
        .createStore(store)
        .then((data) => data)
        .catchError((error) => throw error);
  }

  Future<List<Order>> getOrders2(Map<String, dynamic> params) async {
    return await _orderApi
        .getOrders(params)
        .then((fbList) => fbList.orders)
        .catchError((error) => throw error);
  }

  Future<Order> createOrder(Map<String, dynamic> order) async {
    return _orderApi
        .createOrder(order)
        .then((data) => data)
        .catchError((error) => throw error);
  }

  Future<dynamic> createVisit(Map<String, dynamic> data) async {
    return await _visitApi
        .createVisit(data)
        .then((data) => data)
        .catchError((error) => throw error);
  }

  Future<dynamic> addVisitAction(Map<String, dynamic> data) async {
    return await _visitApi
        .addAction(data)
        .then((data) => data)
        .catchError((error) => throw error);
  }

  Future<List<Note>> getNotes(Map<String, dynamic> params) async {
    return await _noteApi
        .getNotes(params)
        .then((fbList) => fbList.stores)
        .catchError((error) => throw error);
  }

  Future<Note> createNote(Note note) async {
    return await _noteApi
        .createNote(note)
        .then((data) => data)
        .catchError((error) => throw error);
  }

  Future<List<Routing>> getRoutings(Map<String, dynamic> params) async {
    return await _noteApi
        .getRoutings(params)
        .then((fbList) => fbList.routings)
        .catchError((error) => throw error);
  }

  Future<RoutingDetail> getRouting(String routingId) async {
    return await _noteApi
        .getRouting(routingId)
        .then((fbList) => fbList)
        .catchError((error) => throw error);
  }

  Future<Routing> createRouting(Map<String, dynamic> params) async {
    return await _noteApi
        .createRouting(params)
        .then((data) => data)
        .catchError((error) => throw error);
  }

  Future<Rating> createRating(Rating rating) async {
    return await _ratingApi
        .createRating(rating)
        .then((data) => data)
        .catchError((error) => throw error);
  }

  Future<List<Post>> findPostById(int id) {
    //creating filter
    List<Filter> filters = [];

    //check to see if dataLogsType is not null
    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _postDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((error) => throw error);
  }

  Future<int> insert(Post post) => _postDataSource
      .insert(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> update(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> delete(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<User> updateProfile(User user) async {
    return _userApi.updateProfile(user);
  }

  Future<dynamic> getAreas(String type, [String? parentId]) async {
    if (type == 'PROVINCE')
      return _areaApi.getProvinces();
    else if (type == 'DISTRICT')
      return _areaApi.getDistricts(parentId);
    else if (type == 'WARD') return _areaApi.getWards(parentId);
  }

  Future<dynamic> getCategories(String type, [String? parentId]) async {
    if (type == 'channel')
      return _categoryApi.getChannel();
    else if (type == 'channel_1')
      return _categoryApi.getChannel1(parentId);
    else if (type == 'channel_2')
      return _categoryApi.getChannel2(parentId);
    else if (type == 'brand') return _categoryApi.getChannel2(parentId);
  }

  Future<dynamic> getBrandsByCateId(String cateId) async {
    return _brandApi.getBrandsByCateId(cateId);
  }

  Future<Brand> getBrand(String id) async {
    return _brandApi.getBrand(id);
  }

  Future<BrandList> getBrands(Map<String, dynamic> data) async {
    return _brandApi.getBrands(data);
  }

  Future<MyJob> getJob() async {
    return _userApi.getJob();
  }

  Future<void> registerJob(Map<String, dynamic> data) async {
    return _userApi.registerJob(data);
  }

  Future<void> updateJob(Map<String, dynamic> data) async {
    return _userApi.updateJob(data);
  }

  // Login:---------------------------------------------------------------------
  Future<User> login(String email, String password) async {
    return _userApi.login(email, password);
  }

  Future<User> loginSocial(String type, String token) async {
    return _userApi.loginSocial(type, token);
  }

  Future<void> register(
      String fullName, String username, String password) async {
    return _userApi.register(fullName, username, password);
  }

  Future<bool> changePass(String old, String nPass) async {
    return _userApi.changePass(old, nPass);
  }

  Future<bool> logout() async {
    return _userApi.logout();
  }

  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  Future<void> saveAuthToken(String value) =>
      _sharedPrefsHelper.saveAuthToken(value);

  Future<void> saveAuthFreshToken(String value) =>
      _sharedPrefsHelper.saveAuthToken(value);

  Future<void> saveLoggedInUserData(String value) =>
      _sharedPrefsHelper.saveIsLoggedInUserData(value);

  bool deleteUserData() {
    _sharedPrefsHelper.removeAuthToken();
    _sharedPrefsHelper.removeAuthFreshToken();
    _sharedPrefsHelper.removeLoggedInUser();
    return true;
  }

  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;
  Future<String> get isLoggedInUserData =>
      _sharedPrefsHelper.isLoggedInUserData;

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  bool get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  String? get currentLanguage => _sharedPrefsHelper.currentLanguage;
}
