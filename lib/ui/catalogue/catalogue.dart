import 'package:flutter/material.dart';
import '../../widgets/primary_app_bar_widget.dart';
import '../../widgets/product_list_widget.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen();
  @override
  State<StatefulWidget> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimaryAppBar(),
        body: ProductListWidget(height: MediaQuery.of(context).size.height - 123,),
    );
  }
}


