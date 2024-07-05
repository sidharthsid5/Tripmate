import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/HomePages/home.dart';
import 'package:keralatour/Widgets/pallete.dart';

class TourBottomNavigator extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const TourBottomNavigator(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreeenPage.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedindex, _) {
        return BottomNavigationBar(
          currentIndex: updatedindex,
          backgroundColor: Colors.white,
          selectedItemColor: Pallete.green,
          unselectedItemColor: Colors.grey,
          onTap: (newIndex) {
            HomeScreeenPage.selectedIndexNotifier.value = newIndex;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Places'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.location_on_outlined), label: 'Location'),
            BottomNavigationBarItem(
                icon: Icon(Icons.my_library_books_outlined), label: 'Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          ],
        );
      },
    );
  }
}
