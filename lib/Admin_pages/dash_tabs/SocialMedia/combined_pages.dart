import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/dash_tabs/SocialMedia/live_message.dart';
import 'package:keralatour/Admin_pages/dash_tabs/SocialMedia/user_messages.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';

void main() {
  runApp(const ReportsPage(
    title: '',
    content: '',
  ));
}

class ReportsPage extends StatelessWidget {
  const ReportsPage(
      {super.key, required String title, required String content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Social Media Reports'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserMessages(
                        title: '',
                        content: '',
                      ),
                    ),
                  );
                },
                child: const ReportTile(
                  icon: Icons.message,
                  title: 'Message Report',
                  content: 'View user message reports',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LiveMessage(
                        title: '',
                        content: '',
                      ),
                    ),
                  );
                },
                child: const ReportTile(
                  icon: Icons.live_tv,
                  title: 'Live Messages',
                  content: 'View live messages in real-time',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const ReportTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 50, color: const Color.fromARGB(255, 1, 100, 50)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                content,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
