import 'package:boilerplate/widgets/my_app_bar_widget.dart';
import 'package:flutter/material.dart';

class PromotionDetailScreen extends StatefulWidget {
  const PromotionDetailScreen();
  @override
  State<StatefulWidget> createState() => _PromotionDetailScreenState();
}

class _PromotionDetailScreenState extends State<PromotionDetailScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Promotion detail',),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text("Coming soon!"),
          ],
        )
      )
    );
  }
}
