import 'package:flutter/material.dart';
import 'package:keralatour/pages/location_page.dart';
import 'package:keralatour/pages/login_page.dart';
import 'package:keralatour/pages/map.dart';
import 'package:keralatour/pages/status.dart';
import 'package:keralatour/pallete.dart';

import 'popup_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;

  void _login() {
    setState(() {
      isLoggedIn = true;
    });

    _showPopup();
  }

  void _showPopup() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return const PopupContent();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _login();
            },
            foregroundColor: Pallete.whiteColor,
            backgroundColor: Pallete.green,
            shape: const CircleBorder(),
            child: const Icon(Icons.schedule_send),
          ),
          appBar: AppBar(
            backgroundColor: Pallete.green,
            title: const Text("Tourism"),
            titleTextStyle:
                const TextStyle(color: Pallete.whiteColor, fontSize: 20),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _showLogoutDialog(context); // Show logout confirmation dialog
                },
              ),
            ],
          ),
          bottomNavigationBar: menu(),
          body: const TabBarView(
            children: [
              LocationPage(),
              // StatusPage(),
              MapPage(),
              Icon(Icons.settings),
            ],
          ),
        ),
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // Function to show the logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform logout logic here
                // For demonstration purposes, I'll just print a message
                // print('Logout confirmed');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                ); // Close the dialog
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

Widget menu() {
  return Container(
    color: Pallete.green,
    child: const TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Color.fromARGB(179, 182, 179, 179),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Pallete.whiteColor,
      tabs: [
        Tab(
          text: "Location",
          icon: Icon(Icons.location_pin),
        ),
        // Tab(
        //   text: "Schedule",
        //   icon: Icon(Icons.schedule_outlined),
        // ),
        Tab(
          text: "Map",
          icon: Icon(Icons.language_sharp),
        ),
        Tab(
          text: "Setting",
          icon: Icon(Icons.settings),
        ),
      ],
    ),
  );
}
