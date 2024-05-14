import 'package:flutter/material.dart';
import 'package:keralatour/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NaviBar extends StatelessWidget {
  const NaviBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Abhi'),
            accountEmail: const Text('abhijith@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.green,
              // image: DecorationImage(
              //   image: AssetImage('assets/images/logo.png'),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Profile'),
            onTap: () => print('Profile'),
          ),
          ListTile(
            leading: const Icon(Icons.notification_important),
            title: const Text('Notification'),
            onTap: () => print('Notification'),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () => print('Share'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => print('Settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final _sharedPrefs = await SharedPreferences.getInstance();
              await _sharedPrefs.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false); // Close the dialog
            },
          ),
        ],
      ),
    );
  }
}
