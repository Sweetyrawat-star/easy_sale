class Endpoints {
  Endpoints._();

  static const String baseDomain = "http://143.42.71.69:9191/";
  // static const String baseDomain = "http://localhost:9191/";

  // base url
  static const String baseUrl = baseDomain + "api";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  static String getDownloadUrl(String? path, [String? type]) {
    if (path == null || path.isEmpty) {
      if (type == "brand") {
        path = "upload/image/no_image_ad_caei9j9s49g2gh6e8d0g.png";
      } else {
        path = "upload/image/img_mcp_user_urs_c91it9q014me2vdob93g.png";
      }
    }
    return path.startsWith("http") ? path : baseDomain + "api/admin/static/" + path;
  }

  // booking endpoints
  static const String getPosts = baseUrl + "/posts";

  // auth
  static const String refreshToken = baseUrl + "/auth/refresh_token";
  static const String login = baseUrl + "/auth/user/login";
  static const String register = baseUrl + "/auth/user/register";
  static const String logout = baseUrl + "/auth/user/logout";

  // user
  static const String updateProfile = baseUrl + "/auth/user/profile";
  static const String changePass = baseUrl + "/auth/user/reset_pass";
  static const String registerJob = baseUrl + "/job/create";
  static const String getJob = baseUrl + "/job/get";
  static const String updateJob = baseUrl + "/job/update";

  // data
  static const String getFeedbacks = baseUrl + "/feedback/list";
  static const String getAreas = baseUrl + "/area/list";
  static const String getCategories = baseUrl + "/category/list";
  static const String getBrands = baseUrl + "/brand/list";
  static const String getBrand = baseUrl + "/brand/get";

  static const String getStores = baseUrl + "/shop/list";
  static const String getStore = baseUrl + "/shop/get";
  static const String createStore = baseUrl + "/shop/create";

  static const String getNotes = baseUrl + "/diary/list";
  static const String createNote = baseUrl + "/diary/create";

  static const String getRoutings = baseUrl + "/schedule/list";
  static const String createRouting = baseUrl + "/schedule/create";
  static const String getRouting = baseUrl + "/schedule/get";

  static const String getRatings = baseUrl + "/rating/list";
  static const String createRating = baseUrl + "/rating/create";

  static const String getProducts = baseUrl + "/product/list";
  static const String getProductVariants = baseUrl + "/product/variant/list";
  static const String getProduct = baseUrl + "/product/get";
  static const String getProductVariant = baseUrl + "/product/variant/get";

  static const String getCart = baseUrl + "/cart/get";

  static const String getOrders = baseUrl + "/order/list";
  static const String createOrder = baseUrl + "/order/create";

  static const String createVisit = baseUrl + "/visit/create";
  static const String createVisitAction = baseUrl + "/visit/action/create";

  static const String getProviders = baseUrl + "/provider/list";
  static const String getProvider = baseUrl + "/provider/get";

  static const String getKpiTopVariant = baseUrl + "/kpi/variant/top";
  static const String getKpiOverallVariant = baseUrl + "/kpi/variant/overall";
  static const String getKpiOverallOrder = baseUrl + "/kpi/order/overall";
}