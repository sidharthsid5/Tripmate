import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/Auth_Pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/Controller/user_controller.dart';

// ignore: constant_identifier_names
const SAVE_KEY_NAME = 'UserLoggedin';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
          lazy: false,
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tourism Guide',
        // home: CoordinatesPage());
        // home: SplashScreen(),
        // home: YearWiseCountryDistributionPage());
        home: LoginPage());
  }
}
