import 'package:flutter/material.dart';
import 'package:keralatour/pages/location_page.dart';
import 'package:keralatour/pages/login_page.dart';
import 'package:keralatour/pages/map.dart';
import 'package:keralatour/pages/popup_screen.dart';
import 'package:keralatour/pages/schedule.dart';
import 'package:keralatour/pallete.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreeenPage extends StatefulWidget {
  const HomeScreeenPage({super.key});

  @override
  State<HomeScreeenPage> createState() => _HomeScreeenPageState();
}

class _HomeScreeenPageState extends State<HomeScreeenPage> {
  int _currentSelectedIndex = 0;
  final _pages = [
    const LocationPage(),
    const TourScheduleScreen(),
    const MapPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _login();
        },
        foregroundColor: Pallete.green,
        backgroundColor: Pallete.whiteColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.schedule_send),
      ),
      appBar: AppBar(
        backgroundColor: Pallete.whiteColor,
        title: const Text("Tourism"),
        titleTextStyle: const TextStyle(
            color: Pallete.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context); // Show logout confirmation dialog
            },
          ),
        ],
      ),
      body: _pages[_currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Pallete.green,
        currentIndex: _currentSelectedIndex,
        onTap: (newIndex) {
          setState(() {
            _currentSelectedIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_pin), label: 'Location'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule_outlined), label: 'Schedule'),
          BottomNavigationBarItem(
              icon: Icon(Icons.language_sharp), label: 'Map'),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
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
              onPressed: () async {
                final _sharedPrefs = await SharedPreferences.getInstance();
                await _sharedPrefs.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false); // Close the dialog
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

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
}
