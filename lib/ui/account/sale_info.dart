
import 'package:boilerplate/widgets/my_app_bar_widget.dart';
import 'package:flutter/material.dart';

class SaleInfoScreen extends StatefulWidget {
  const SaleInfoScreen();
  @override
  State<StatefulWidget> createState() => _SaleInfoScreenState();
}

class _SaleInfoScreenState extends State<SaleInfoScreen> {

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
      appBar: MyAppBar(title: 'Policies',),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text("Coming soon!"),
          ],
        ),
      )
    );
  }
}
