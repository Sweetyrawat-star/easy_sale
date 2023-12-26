import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/flash_message_widget.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen();
  @override
  State<StatefulWidget> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  late List<Widget> images = [];
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _newPass2Controller = TextEditingController();

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
      appBar: SimpleAppBar(
        title: "Change password",
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            AppSimpleInputWidget(
              "Input old password",
              textController: _oldPassController,
              isObscure: true,
            ),
            SizedBox(height: 20,),
            AppSimpleInputWidget(
              "Input new password",
              textController: _newPassController,
              isObscure: true,
            ),
            SizedBox(height: 20,),
            AppSimpleInputWidget(
              "Re-input new password",
              textController: _newPass2Controller,
              isObscure: true,
            ),
            SizedBox(height: 20,),
            PrimaryButtonWidget(
              buttonWidth: MediaQuery.of(context).size.width - 40,
              buttonText: "Submit",
              onPressed: () {
                if (_oldPassController.text.length < 6
                    || _newPassController.text.length < 6
                    || _newPass2Controller.text.length < 6) {
                  FlashMessageWidget.flashError(
                      context, "Please enter all information, password must be at least 6 characters.");
                } else if (_newPassController.text != _newPass2Controller.text) {
                  FlashMessageWidget.flashError(
                      context, "The new password and the re-inputed password do not match.");
                } else {
                  // _repository.changePass(_oldPassController.text, _newPassController.text).then((_) {
                  //   CommonDialogWidget.success(
                  //       context,
                  //       "Change password successful!",
                  //           (p0) => {
                  //           _userStore.logout().then((value) {
                  //             Navigator.of(context).pushReplacementNamed(Routes.login);
                  //           }).catchError((e) {
                  //             Navigator.of(context).pushReplacementNamed(Routes.login);
                  //           })
                  //       });
                  // }).catchError((err) {
                  //   FlashMessageWidget.flashError(context, err.toString());
                  // });
                  FlashMessageWidget.flashError(context, "Can't change password of demo user!");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
