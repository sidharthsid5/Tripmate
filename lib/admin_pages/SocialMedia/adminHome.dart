import 'package:flutter/material.dart';
import 'package:keralatour/admin_pages/SocialMedia/live_message.dart';
import 'package:keralatour/admin_pages/SocialMedia/user_messages.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            ReportCard(
              icon: Icons.bar_chart,
              title: 'Demographic Report',
              onTap: () {
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
            Icon(icon, size: 50, color: Colors.blue),
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
