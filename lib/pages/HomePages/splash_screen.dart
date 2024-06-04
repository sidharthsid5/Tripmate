import 'package:flutter/material.dart';
import 'package:keralatour/main.dart';
import 'package:keralatour/pages/HomePages/home.dart';
import 'package:keralatour/pages/Auth%20Pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: 150,
        ),
      ),
    );
  }

  Future<void> gotoLogin() async {
    await Future.delayed(
      const Duration(seconds: 4),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const LoginPage(),
      ),
    );
  }

  Future<void> checkUserLoggedIn() async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    final _userLoggedIn = _sharedPrefs.getBool(SAVE_KEY_NAME);
    if (_userLoggedIn == null || _userLoggedIn == false) {
      gotoLogin();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx1) => const HomeScreeenPage()),
      );
    }
  }
}
