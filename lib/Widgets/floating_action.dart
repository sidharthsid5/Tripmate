import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/HomePages/Schedule/interest_page.dart';
import 'package:keralatour/Widgets/pallete.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final int userId;
  final Function(int) onAddSchedule;

  const CustomFloatingActionButton({
    Key? key,
    required this.userId,
    required this.onAddSchedule,
  }) : super(key: key);

  void _schedulePopup(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return PopupContent(userId: userId); // Pass userId to PopupContent
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        onAddSchedule(userId);
        _schedulePopup(context);
      },
      foregroundColor: Pallete.green,
      backgroundColor: Pallete.whiteColor,
      shape: const CircleBorder(),
      child: const Icon(Icons.schedule_send),
    );
  }
}
