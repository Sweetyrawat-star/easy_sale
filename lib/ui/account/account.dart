import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/account/change_pass.dart';
import 'package:boilerplate/ui/account/my_job.dart';
import 'package:boilerplate/ui/account/sale_info.dart';
import 'package:boilerplate/ui/account/two_step.dart';
import 'package:boilerplate/ui/account/update_profile.dart';
import 'package:boilerplate/ui/account/widgets/custom_list_tite.dart';
import 'package:boilerplate/ui/order/man_order.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../constants/assets.dart';
import '../../utils/routes/routes.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen();
  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _userStore = Provider.of<UserStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAccountAppBar(),
        Container(
          height: MediaQuery.of(context).size.height - 361,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomListTile(
                    icon: Image.asset(Assets.changPasswordIcon,
                        width: 34, height: 34),
                    text: 'Change password',
                    onTap: () => {
                      NavigationService.push(context, ChangePassScreen())
                    }),
                CustomListTile(
                    icon: Image.asset(Assets.folderIcon, width: 26, height: 26),
                    text: 'Manage orders',
                    onTap: () => {
                      NavigationService.push(context, ManageOrderScreen())
                    }),
                CustomListTile(
                    icon: Image.asset(Assets.makeNoticeIcon, width: 35, height: 35),
                    text: 'Policies',
                    onTap: () => {
                      NavigationService.push(context, SaleInfoScreen())
                    }),
                CustomListTile(
                    icon: Image.asset(Assets.workIcon, width: 26, height: 26),
                    text: 'Update job info',
                    onTap: () => {
                      NavigationService.push(context, MyJobScreen())
                    }),
                CustomListTile(
                    icon: Image.asset(Assets.userGuideIcon, width: 30, height: 30),
                    text: 'User guide',
                    onTap: () => {
                      NavigationService.push(context, TwoStepScreen())
                    }),
              ],
            ),
          ),
        ),
        Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Image.asset(
                          Assets.powerIcon,
                          height: 26,
                          width: 26,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Logout",
                          style: AppStyles.textStyle14Regular,
                        )
                      ],
                    ),
                    onTap: () {
                      _userStore.logout().then((value) {
                        Navigator.of(context).pushReplacementNamed(Routes.login);
                      }).catchError((e) {
                        Navigator.of(context).pushReplacementNamed(Routes.login);
                      });
                    },
                  ),
                  SizedBox(height: 20.0,),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return Text('App version: ${snapshot.data?.version} - build: ${snapshot.data?.buildNumber}', style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.greyPrice)));
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                  SizedBox(height: 15.0,)
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  _buildAccountAppBar() {
    return Container(
      height: 170.0,
      decoration: BoxDecoration(
          color: AppColors.green[200],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.green[200]!,
              AppColors.green[200]!.withOpacity(0),
            ],
          )
      ),
      child: Container(
        padding: EdgeInsets.only(top: 60, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // color: Colors.red,
              padding: EdgeInsets.only(left: 20),
              width: 120,
              height: 150,
              child: Observer(builder: (_) => CircleAvatar(
                  foregroundColor: Colors.blue,
                  backgroundColor: AppColors.green[200],
                  // radius: 70.0,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: Endpoints.getDownloadUrl(_userStore.currentUserData.avatar),
                      fit: BoxFit.cover,
                      width: 86.0,
                      height: 86.0,
                    ),
                  )))
              ,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
              width: MediaQuery.of(context).size.width - 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Observer(builder: (context) {
                    return FittedBox(
                      fit: BoxFit.contain,
                      child: Text(_userStore.currentUserData.fullName ?? _userStore.currentUserData.email!, style: AppStyles.textStyle20RegularBold,),
                    );
                  }),
                  InkWell(
                    child: Text("Update account info", style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.green[500]))),
                    onTap: () {
                      NavigationService.push(context, UpdateProfileScreen());
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
