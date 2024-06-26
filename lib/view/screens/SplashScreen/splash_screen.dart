import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
import 'package:wave/utils/constants/preferences.dart';
import 'package:wave/utils/routing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    decideNavigation();
    // _navigateToLogin();
  }

  decideNavigation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Pref.login_pref)) {
      if (prefs.getBool(Pref.login_pref) ?? false) {
        _navigatetohome(prefs.getString(Pref.user_id)!);
      } else {
        _navigateToLogin();
      }
    } else {
      _navigateToLogin();
    }
  }

  _navigateToLogin() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});
    Get.offNamed(AppRoutes.loginScreen);
  }

  _navigatetohome(String userId) async {
    var userProvider = Provider.of<UserDataController>(context, listen: false);
    await userProvider.setUser(userID: userId);
    "User set to ${userProvider.user!.name}".printInfo();
    "My fcm token = ${userProvider.user!.fcmToken}".printInfo();
    "My followings = ${userProvider.user!.following}".printInfo();
    Get.offNamed(AppRoutes.homeNavigationScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 193, 198, 241),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              CustomLogo.primaryLogo,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
