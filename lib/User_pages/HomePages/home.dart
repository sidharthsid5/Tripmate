import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/left_navigator.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Location/live_loc.dart';
import 'package:keralatour/User_pages/HomePages/Location/map_pscreen.dart';
import 'package:keralatour/User_pages/HomePages/Places/places.dart';
import 'package:keralatour/User_pages/HomePages/Schedule/interest_page.dart';
import 'package:keralatour/User_pages/HomePages/Schedule/schedule_history.dart';
import 'package:keralatour/Widgets/pallete.dart';
import 'package:provider/provider.dart';

class HomeScreeenPage extends StatefulWidget {
  final int userId;

  const HomeScreeenPage({Key? key, required this.userId}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<HomeScreeenPage> createState() => _HomeScreeenPageState();
}

class _HomeScreeenPageState extends State<HomeScreeenPage> {
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetails(widget.userId);
  }

  void _initializePages() {
    _pages = [
      TouristPlacesScreen(
        userId: widget.userId,
      ),
      LocationPage(
        userId: widget.userId,
      ),
      ScheduleHistory(
        userId: widget.userId,
      ),
      MapPage(
        userId: widget.userId,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NaviBar(userId: widget.userId),
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
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: HomeScreeenPage.selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
    );
  }

  // void _showLogoutDialog(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Confirm Logout"),
  //         content: const Text("Are you sure you want to log out?"),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               final _sharedPrefs = await SharedPreferences.getInstance();
  //               await _sharedPrefs.clear();
  //               Navigator.of(context).pushAndRemoveUntil(
  //                   MaterialPageRoute(builder: (context) => const LoginPage()),
  //                   (route) => false);
  //             },
  //             child: const Text("Logout"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
          return PopupContent(userId: widget.userId);
        },
      ),
    );
  }
}
