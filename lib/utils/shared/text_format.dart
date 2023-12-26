import 'package:intl/intl.dart';

class CurrencyFormat {
  static String vnd(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      return value + ' đ';
    } else {
      return price;
    }
  }

  static String usd(String price) {
    if (price.length > 2) {
      final oCcy = new NumberFormat("#,##0.00", "en_US");
      return '\$' + oCcy.format(double.parse(price));
    } else {
      return price;
    }
  }
}

class PhoneFormat {
  static String vn(String phone) {
    if (phone.length == 10) {
      return phone.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "(${m[1]}) ${m[2]}-${m[3]}");
    } else {
      return phone;
    }
  }
}