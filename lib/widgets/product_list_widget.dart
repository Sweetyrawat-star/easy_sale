import 'package:boilerplate/models/variant/variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import '../constants/colors.dart';
import '../data/repository.dart';
import '../di/components/service_locator.dart';
import 'variant_list_item_widget.dart';

class ProductListWidget extends StatefulWidget {
  final double height;
  final Color? bgColor;
  final Map<String, dynamic>? queryParams;

  const ProductListWidget({
    Key? key,
    required this.height,
    this.bgColor,
    this.queryParams,
  });

  @override
  State<StatefulWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final Repository _repository = getIt<Repository>();
  late String searchKey = "";
  late PagewiseLoadController<ProductVariant> _pagewiseLoadController;

  @override
  void initState() {
    super.initState();
    if (widget.queryParams != null) {

    }
    _pagewiseLoadController = PagewiseLoadController<ProductVariant>(
        pageSize: 10,
        pageFuture: (pageIndex) => _repository.getProductVariants({...{
          "page": (pageIndex ?? 0) + 1,
          "item_per_page": 10,
        }, ...?widget.queryParams}).then((list) => list.productVariants));
    _pagewiseLoadController.addListener(() {
      if (this._pagewiseLoadController.hasMoreItems == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No More Items!'),
          backgroundColor: AppColors.green[500],
        ));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor ?? Colors.white,
      height: widget.height,
      child: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
        onRefresh: () async {
          _pagewiseLoadController.reset();
          await Future.value({});
        },
        child: PagewiseListView<ProductVariant>(
          itemBuilder: _buildListItem,
          pageLoadController: _pagewiseLoadController,
          errorBuilder: (context, error) {
            print('error: $error');
            return Text('Error: $error');
          },
          showRetry: false,
          noItemsFoundBuilder: (context) => Center(child: Text("No item found"),),
        ));
      // RefreshIndicator(
      //   onRefresh: () async {
      //     await Future.value({});
      //   },
      //   child: PagewiseGridView.count(
      //     pageSize: 10,
      //     crossAxisCount: 2,
      //     mainAxisSpacing: 15.0,
      //     crossAxisSpacing: 10.0,
      //     childAspectRatio: 0.7,
      //     padding: EdgeInsets.all(10.0),
      //     itemBuilder: _buildListItem,
      //     pageFuture: (pageIndex) => _repository.getProductVariants({
      //       "page": (pageIndex ?? 0) + 1,
      //       "item_per_page": 10,
      //     }).then((list) => list.productVariants),
      //   ));
  }

  Widget _buildListItem(context, ProductVariant _variant, _) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: VariantListItemWidget(
          variant: _variant,
          color: Colors.white,
          onAddToCart: () {

          },
        ),
      )
    );
  }

  // Future<CartItem> _addToCart(ProductVariant _variant) {
  //   CartItem item = CartItem(
  //     id: _variant.id,
  //     name: _variant.name ?? "",
  //     qty: 1,
  //     price: _variant.price ?? 0,
  //     brand: currentProduct.brand?.name ?? "",
  //     attrs: selectedAttributes.map((e) => e.attrValueName).join(", "),
  //     image: _variant.images[0],
  //   );
  //   Cart? cart = _cartStore.cart;
  //   cart?.items = _cartStore.list?.toList() ?? [];
  //   cart?.items.add(item);
  //   return _repository.updateCart(cart!).then((value) => item);
  // }
}
