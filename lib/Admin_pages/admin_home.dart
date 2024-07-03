import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/SocialMedia/live_message.dart';
import 'package:keralatour/Admin_pages/SocialMedia/user_messages.dart';
import 'package:keralatour/Admin_pages/Graph/chart.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/Auth_Pages/login_page.dart';
import 'package:keralatour/Widgets/left_navigator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsPage extends StatefulWidget {
  final int userId;
  const ReportsPage({super.key, required this.userId});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context); // Show logout confirmation dialog
            },
          ),
        ],
      ),
      drawer: NaviBar(userId: widget.userId),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            ReportCard(
              icon: Icons.bar_chart,
              title: 'Demographic Report',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TouristDetailScreen(),
                  ),
                );
                // Navigate to Demographic Report
              },
            ),
            ReportCard(
              icon: Icons.people,
              title: 'User Behavior Report',
              onTap: () {
                // Navigate to User Behavior Report
              },
            ),
            ReportCard(
              icon: Icons.trending_up,
              title: 'Trend Analysis Report',
              onTap: () {
                // Navigate to Trend Analysis Report
              },
            ),
            ReportCard(
              icon: Icons.insights,
              title: 'Demand Prediction Report',
              onTap: () {
                // Navigate to Demand Prediction Report
              },
            ),
            ReportCard(
              icon: Icons.feedback,
              title: 'User Feedback Report',
              onTap: () {
                // Navigate to User Feedback Report
              },
            ),
            ReportCard(
              icon: Icons.attach_money,
              title: 'Revenue and Financial Report',
              onTap: () {},
            ),
            ReportCard(
              icon: Icons.spatial_tracking,
              title: 'Live Message Tracking',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveMessage(),
                  ),
                );
                // Navigate to Revenue and Financial Report
              },
            ),
            ReportCard(
              icon: Icons.my_library_books_outlined,
              title: 'Message Report',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserMessages(),
                  ),
                );
                // Navigate to Revenue and Financial Report
              },
            ),
          ],
        ),
      ),
    );
  }
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
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final _sharedPrefs = await SharedPreferences.getInstance();
              await _sharedPrefs.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false); // Close the dialog
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}

class ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ReportCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.teal),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
