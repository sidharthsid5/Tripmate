import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/HomePages/home.dart';
import 'package:keralatour/Widgets/pallete.dart';

class TourBottomNavigator extends StatelessWidget {
  const TourBottomNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreeenPage.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedindex, _) {
        return BottomNavigationBar(
          currentIndex: updatedindex,
          selectedItemColor: Pallete.green,
          unselectedItemColor: Colors.grey,
          onTap: (newIndex) {
            HomeScreeenPage.selectedIndexNotifier.value = newIndex;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_pin), label: 'Location'),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule_outlined), label: 'Schedule'),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule_send), label: 'Schedule History'),
            BottomNavigationBarItem(
                icon: Icon(Icons.language_sharp), label: 'Map'),
          ],
        );
      },
    );
  }
}
