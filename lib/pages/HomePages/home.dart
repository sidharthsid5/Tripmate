import 'package:flutter/material.dart';
import 'package:keralatour/Navigator_bar/navi_bar.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:keralatour/pages/HomePages/live_loc.dart';
import 'package:keralatour/pages/Auth%20Pages/login_page.dart';
import 'package:keralatour/pages/HomePages/map_pscreen.dart';
import 'package:keralatour/pages/HomePages/places.dart';
import 'package:keralatour/pages/Schedule/interest_page.dart';
import 'package:keralatour/pages/Schedule/schedule.dart';
import 'package:keralatour/pages/Schedule/schedule_history.dart';
import 'package:keralatour/pallete.dart';
import 'package:keralatour/widgets/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class HomeScreeenPage extends StatefulWidget {
  final int userId;

  const HomeScreeenPage({Key? key, required this.userId}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<HomeScreeenPage> createState() => _HomeScreeenPageState();
}

class _HomeScreeenPageState extends State<HomeScreeenPage> {
  final _pages = [
    const TouristPlacesScreen(),
    const LocationPage(),
    const TourScheduleScreen(),
    const ScheduleHistory(),
    const MapPage(),
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NaviBar(userId: widget.userId), // Pass userId to NaviBar
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addSchedule();
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
          fontStyle: FontStyle.italic,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context); // Show logout confirmation dialog
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: HomeScreeenPage.selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      bottomNavigationBar: const TourBottomNavigator(),
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

  bool addSchedule = false;

  void _addSchedule() {
    setState(() {
      addSchedule = true;
    });

    _schedulePopup();
  }

  void _schedulePopup() {
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
