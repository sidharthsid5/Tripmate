import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/Auth_Pages/login_page.dart';
import 'package:keralatour/Widgets/pallete.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({Key? key, required this.title, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Pallete.whiteColor,
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: Pallete.green,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
      actions: actions ??
          [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
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
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final _sharedPrefs = await SharedPreferences.getInstance();
                await _sharedPrefs.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
