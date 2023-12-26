import 'package:boilerplate/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:math' as math;
import '../apis/google_signin_api.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';

typedef void SocialLoggedInCallback(String type, String accessToken);
class SocialLoginWidget extends StatelessWidget {
  final double? width;
  final SocialLoggedInCallback onLoggedIn;

  const SocialLoginWidget({
    Key? key,
    this.width,
    required this.onLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == null ? MediaQuery.of(context).size.width - 40 : width,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.thinLineIcon),
              SizedBox(width: 10,),
              Text('Or', style: AppStyles.textStyle16Regular400),
              SizedBox(width: 10,),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(Assets.thinLineIcon),
              ),
            ],
          ),
          // SizedBox(height: 20.0,),
          // _buildSocialButton("Zalo", Assets.zaloIcon),
          // SizedBox(height: 10.0,),
          // _buildSocialButton("Facebook", Assets.fbIcon, context),
          SizedBox(height: 10.0,),
          _buildSocialButton("Google", Assets.ggIcon, context),
        ],
      ),
    );
  }

  _buildSocialButton(String socialName, String socialIconPath, BuildContext context) {
    return Container(
      height: 48.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.disableBgColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue with ' + socialName, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),)
                  ],
                )
              ],
            ),
            Positioned(
              top: 13,
              left: 14,
              child: Container(
                  width: 22.0,
                  height: 22.0,
                  child: Image.asset(socialIconPath)
              ),
            )
          ],
        ),
        onTap: () {
          if (socialName == 'Google') {
            GoogleSigninApi.login().then((result){
              result?.authentication.then((googleKey){
                print(googleKey.accessToken);
                onLoggedIn('google', googleKey.accessToken ?? '');
              }).catchError((err){
                print('inner error');
              });
            }).catchError((err){
              print('error occured');
            });
          } else if (socialName == 'Facebook') {
            FacebookAuth.instance.login().then((result) {
              if (result.status == LoginStatus.success) {
                // you are logged
                print(result.accessToken);
              } else {
                print(result.status);
                print(result.message);
              }
            });
          }
        },
      )
    );
  }
}
