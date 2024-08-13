import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/SocialMedia/live_message.dart';
import 'package:keralatour/Admin_pages/SocialMedia/user_messages.dart';

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
      appBar: AppBar(
        title: const Text('Social Media Reports'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
                child: ReportTile(
                  icon: Icons.message,
                  title: 'Message Report',
                  content: 'View user message reports',
                ),
              ),
            ),
            SizedBox(width: 8),
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
                child: ReportTile(
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

  ReportTile({required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
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
              Icon(icon, size: 50, color: Color.fromARGB(255, 1, 100, 50)),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
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
