


import 'package:flutter/material.dart';

import 'preference/PreferencesKey.dart';
import 'preference/app_preference.dart';




class SplashServices {
  void checkAuthentication(BuildContext context) async {
    Future.delayed(const Duration(seconds: 1), () {
       

      if (AppPreference().getString(PreferencesKey.token).isEmpty ||
          AppPreference().getString(PreferencesKey.token) == "") {
        //Get.to(LangvangeSelection());
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => AimaLoginScreen()),
        // );
      } else {
      //  Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => MainDashboard()),
      //     );

      }
      // Navigator.popAndPushNamed(context, RoutesName.loginscreen);
    });
  }
}
