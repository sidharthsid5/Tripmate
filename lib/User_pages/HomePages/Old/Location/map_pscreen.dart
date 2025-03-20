import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/bottom_navigation.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';

import 'package:keralatour/Widgets/side_navigator.dart';

class MapPage extends StatefulWidget {
  final int userId;

  const MapPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: const CustomAppBar(title: 'Tourism'),
      drawer: NaviBar(userId: widget.userId), // Add the drawer here
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/a.png',
                width: 1000,
                height: 670,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TourBottomNavigator(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
