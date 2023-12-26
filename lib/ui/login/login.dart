import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/circle_logo_widget.dart';
import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/flash_message_widget.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/social_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import '../../widgets/primary_button_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');

  //stores:---------------------------------------------------------------------
  // late ThemeStore _themeStore;
  late UserStore _userStore;

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  //repository

  //stores:---------------------------------------------------------------------
  final _store = FormStore();
  String _eyeIcon = Assets.eyeClosedIcon;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _themeStore = Provider.of<ThemeStore>(context);
    _userStore = Provider.of<UserStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Center(
                child: SingleChildScrollView(
              child: _buildForm(),
            )),
            Observer(
              builder: (context) {
                return _userStore.success
                    ? navigate(context)
                    : _showErrorMessage(_userStore.errorStore.errorMessage);
              },
            ),
            Observer(
              builder: (context) {
                return Visibility(
                  visible: _userStore.isLoading,
                  child: CustomProgressIndicatorWidget(),
                );
              },
            )
          ],
        ));
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: CircleLogoWidget(width: 110.0, height: 110.0),
          ),
          Container(
              padding: EdgeInsets.only(top: 13),
              child: Text('Welcome!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
          Container(
            padding: EdgeInsets.only(top: 40),
            child: _buildUserIdField(),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: _buildPasswordField(),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: _buildSignInButton(),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Text('Forgot password?',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor)),
                  onTap: () {
                    FlashMessageWidget.flashInfo(context, 'Coming soon!');
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: SocialLoginWidget(
              onLoggedIn: (type, token) async {
                try {
                  await _userStore.loginSocial(type, token);
                } catch (e) {
                  FlashMessageWidget.flashError(context, e.toString());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserIdField() {
    return AppSimpleInputWidget(
      "Input username",
      textController: _userEmailController,
      onChanged: (value) {
        _store.setUserId(_userEmailController.text);
      },
      prefixIcon: Padding(
        padding: EdgeInsets.all(12),
        child: Image.asset(
          Assets.userIcon,
          height: 24,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return AppSimpleInputWidget(
      "Input password",
      textController: _passwordController,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        _store.setUserId(_passwordController.text);
      },
      isObscure: _isObscure,
      prefixIcon: Padding(
        padding: EdgeInsets.all(12),
        child: Image.asset(
          Assets.lockedIcon,
          height: 24,
        ),
      ),
      suffixIcon: InkWell(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Image.asset(
            _eyeIcon,
            height: 24,
          ),
        ),
        onTap: () {
          setState(() {
            _isObscure = !_isObscure;
            _eyeIcon = _isObscure ? Assets.eyeClosedIcon : Assets.eyeOpenedIcon;
          });
        },
      ),
    );
  }

  // Widget _buildForgotPasswordButton() {
  //   return Align(
  //     alignment: FractionalOffset.centerRight,
  //     child: TextButton(
  //       child: Text(
  //         AppLocalizations.of(context).translate('login_btn_forgot_password'),
  //         style: Theme.of(context)
  //             .textTheme
  //             .caption
  //             ?.copyWith(color: Colors.orangeAccent),
  //       ),
  //       onPressed: () {},
  //     ),
  //   );
  // }

  Widget _buildSignInButton() {
    return PrimaryButtonWidget(
      buttonText: AppLocalizations.of(context).translate('login_btn_sign_in'),
      onPressed: () async {
        // if (_store.canLogin) {
        DeviceUtils.hideKeyboard(context);
        try {
          await _userStore.login(
              _userEmailController.text, _passwordController.text);
        } catch (e) {
          FlashMessageWidget.flashError(context, e.toString());
        }
        // } else {
        //   _showErrorMessage('Please fill in all fields');
        // }
      },
      buttonWidth: MediaQuery.of(context).size.width - 40,
    );
  }

  Widget navigate(BuildContext context) {
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setBool(Preferences.is_logged_in, true);
    // });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.main, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        MotionToast.error(
                // title:  Text("Error"),
                description: Text(message))
            .show(context);
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
