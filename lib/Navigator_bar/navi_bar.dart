import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:keralatour/pages/Auth%20Pages/login_page.dart';
import 'package:keralatour/pages/Auth%20Pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NaviBar extends StatelessWidget {
  const NaviBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return UserAccountsDrawerHeader(
                accountName: const Text('Abhi Lal'),
                accountEmail: const Text("abhi@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset('assets/images/profile.jpg'),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
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

class UserDetails {
  final int userid;
  final String email;
  final String name;

  UserDetails({
    required this.userid,
    required this.email,
    required this.name,
  });

  factory UserDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return UserDetails(
      userid: json['uid'] ?? 0,
      email: json['uemail'] ?? 'Unknown',
      name: json['uname'] ?? 'Unknown',
    );
  }
}
