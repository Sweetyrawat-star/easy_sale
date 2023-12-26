import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../di/components/service_locator.dart';
import '../models/variant/variant.dart';
import '../models/variant/variant_list.dart';
import '../ui/product/detail_product.dart';
import '../utils/shared/nav_service.dart';


class PrimarySearchInputWidget extends StatelessWidget {
  final String? hintText;
  final Widget? leftIcon;
  final double? height;
  final double? width;

  const PrimarySearchInputWidget({
    Key? key,
    this.hintText,
    this.leftIcon,
    this.height = 40,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      width: this.width,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: BorderSide(width: 0.0, style: BorderStyle.none)
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800], fontSize: 14),
          hintText: this.hintText,
          fillColor: Colors.white70,
          isCollapsed: true,
          contentPadding: EdgeInsets.all(10.0),
          prefixIcon: this.leftIcon
        ),
        textAlignVertical: TextAlignVertical.center,
        onTap: () async {
          await showSearch<String>(
          context: context,
          delegate: CustomDelegate(),
          );
        },
      ),
    );
  }
}

class CustomDelegate extends SearchDelegate<String> {
  final Repository _repository = getIt<Repository>();
  List<String> data = ["romeo", "julie", "roma", "july", "hello world"];

  @override
  List<Widget> buildActions(BuildContext context) => [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: Icon(Icons.chevron_left), onPressed: () => close(context, ''));

  @override
  Widget buildSuggestions(BuildContext context) => Container();

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<ProductVariantList>(
      future: _repository.getProductVariants({
        "page": 1,
        "item_per_page": 100,
        "keyword": query
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemBuilder: (context, index) {
              ProductVariant? variant = snapshot.data?.productVariants[index];
              return ListTile(
                title: Text(variant?.name ?? ""),
                onTap: () {
                  NavigationService.push(
                    context,
                    DetailProductScreen(
                      productId: variant?.productId ?? "",
                      variantId: variant?.id,
                    ),
                  ).then((value) => {});
                },
              );
            },
            itemCount: snapshot.data?.productVariants.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    // List<String> listToShow = [];
    // if (query.isNotEmpty) {
    //   _repository.getProductVariants({
    //     "page": 1,
    //     "item_per_page": 100,
    //     "keyword": query
    //   }).then((list) => {
    //     listToShow = List.from(list.productVariants.map((e) => e.name))
    //   });
    // } else {
    //   listToShow = data;
    // }
    //
    // return ListView.builder(
    //   itemCount: listToShow.length,
    //   itemBuilder: (_, i) {
    //     var noun = listToShow[i];
    //     return ListTile(
    //       title: Text(noun),
    //       onTap: () => close(context, noun),
    //     );
    //   },
    // );
  }
}