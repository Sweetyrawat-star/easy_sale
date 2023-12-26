import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/widgets/circle_logo_widget.dart';
import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../di/components/service_locator.dart';
import '../../widgets/app_simple_label_widget.dart';
import '../../widgets/flash_message_widget.dart';
import '../../widgets/primary_button_widget.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final Repository _repository = getIt<Repository>();
  late bool loading = false;

  //stores:---------------------------------------------------------------------
  // late ThemeStore _themeStore;
  late UserStore _userStore;

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  //repository

  //stores:---------------------------------------------------------------------
  final _store = FormStore();

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
          Center(child: _buildForm()),
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
                visible: _userStore.isLoading || loading,
                child: CustomProgressIndicatorWidget(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 112),
            child: CircleLogoWidget(width: 80.0, height: 80.0),
          ),
          Padding(
              padding: EdgeInsets.only(top: 13),
              child: Text('Đăng ký',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [AppSimpleLabelWidget("Họ và tên")],
          ),
          SizedBox(
            height: 10,
          ),
          _buildFullNameField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [AppSimpleLabelWidget("Số điện thoại")],
          ),
          SizedBox(
            height: 10,
          ),
          _buildUserIdField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [AppSimpleLabelWidget("Mật khẩu")],
          ),
          SizedBox(
            height: 10,
          ),
          _buildPasswordField(),
          SizedBox(
            height: 20,
          ),
          _buildSignInButton(),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Text('Đăng nhập',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullNameField() {
    return AppSimpleInputWidget(
          "Nhập họ tên",
          textController: _fullNameController,
          onChanged: (value) {
            _store.setUserId(_fullNameController.text);
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

  Widget _buildUserIdField() {
    return AppSimpleInputWidget(
          "Nhập số điện thoại",
          textController: _usernameController,
          prefixIcon: Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.phone_android_outlined,
              size: 24,
              color: AppColors.greyPrice,
            ),
          ),
        );
  }

  Widget _buildPasswordField() {
    return AppSimpleInputWidget(
          "Nhập mật khẩu",
          textController: _passwordController,
          keyboardType: TextInputType.number,
          isObscure: true,
          prefixIcon: Padding(
            padding: EdgeInsets.all(12),
            child: Image.asset(
              Assets.lockedIcon,
              height: 24,
            ),
          ),
        );
  }

  Widget _buildSignInButton() {
    return PrimaryButtonWidget(
      buttonText: "Đăng ký",
      onPressed: () async {
        if (_fullNameController.text.isEmpty
            || _usernameController.text.isEmpty
            || _passwordController.text.isEmpty) {
          FlashMessageWidget.flashError(context, "Vui lòng nhập tất cả thông tin");
        } else if (_usernameController.text.length < 10 || !_usernameController.text.startsWith("0")) {
          FlashMessageWidget.flashError(context, "Số điện thoại không đúng định dạng");
        } else if (_passwordController.text.length < 6) {
          FlashMessageWidget.flashError(context, "Mật khẩu tối thiểu 6 ký tự");
        } else {
          DeviceUtils.hideKeyboard(context);
          setState(() {
            loading = true;
          });
          _repository.register(
            _fullNameController.text,
            _usernameController.text,
            _passwordController.text,
          ).then((data) async {
            setState(() {
              loading = true;
            });
            await _userStore.login(_usernameController.text, _passwordController.text);
          }).catchError((e) {
            setState(() {
              loading = false;
            });
            FlashMessageWidget.flashError(context, e.toString());
          });
        }
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
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
