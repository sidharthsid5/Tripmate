import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/Auth_Pages/login_page.dart';
import 'package:keralatour/User_pages/Auth_Pages/profile.dart';
import 'package:keralatour/User_pages/HomePages/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NaviBar extends StatelessWidget {
  final int userId;

  const NaviBar({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              if (userProvider.firstName == null ||
                  userProvider.lastName == null ||
                  userProvider.email == null) {
                return UserAccountsDrawerHeader(
                  accountName: const Text("Loading..."),
                  accountEmail: const Text(""),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset('assets/images/profile.jpg'),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                );
              } else {
                return UserAccountsDrawerHeader(
                  accountName: Text(
                      "${userProvider.firstName} ${userProvider.lastName}"),
                  accountEmail: Text("${userProvider.email}"),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset('assets/images/profile.jpg'),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const HomeScreeenPage(
                          userId: 1,
                        )),
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
