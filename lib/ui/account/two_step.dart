import 'package:boilerplate/widgets/my_app_bar_widget.dart';
import 'package:flutter/material.dart';

class TwoStepScreen extends StatefulWidget {
  const TwoStepScreen();
  @override
  State<StatefulWidget> createState() => _TwoStepScreenState();
}

class _TwoStepScreenState extends State<TwoStepScreen> {

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
      appBar: MyAppBar(title: 'User guide',),
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
