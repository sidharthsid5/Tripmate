import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/left_navigator.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Location/live_loc.dart';
import 'package:keralatour/User_pages/HomePages/Location/map_pscreen.dart';
import 'package:keralatour/User_pages/HomePages/Places/places.dart';
import 'package:keralatour/User_pages/HomePages/Schedule/schedule_history.dart';
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
  // bool addSchedule = false;
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

  // void _addSchedule(int userId) {
  //   setState(() {
  //     addSchedule = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NaviBar(userId: widget.userId), // Use NaviBar with userId
      backgroundColor: Colors.grey[200],
      // floatingActionButton: CustomFloatingActionButton(
      //   userId: widget.userId,
      //   onAddSchedule: _addSchedule,
      // ),
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
}
