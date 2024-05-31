import 'package:flutter/material.dart';
import 'package:keralatour/pages/Home%20Pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/controller/user_controller.dart';

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
      // home: ScheduleHistory(),
      home: SplashScreen(),
      //home: TravelSummaryScreen(),
    );
  }
}
