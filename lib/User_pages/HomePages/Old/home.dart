import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/HomePages/Old/Places/places.dart';
import 'package:keralatour/User_pages/HomePages/Old/user_dashboard.dart';
import 'package:keralatour/Widgets/side_navigator.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Old/Location/map_pscreen.dart';
import 'package:keralatour/User_pages/HomePages/Old/Schedule/schedule_history.dart';
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
      DashboardScreen(
        userId: widget.userId,
      ),
      TouristPlacesScreen(
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
      drawer: NaviBar(userId: widget.userId), // Use NaviBar with userId
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),
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
