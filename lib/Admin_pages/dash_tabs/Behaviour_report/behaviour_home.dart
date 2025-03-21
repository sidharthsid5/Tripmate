import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/coordinates_table.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/image_page.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/places_tablepage.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/tourism_datapage.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/user_behaviour.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/user_clustering.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/user_similarity.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/usermessage_table.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';

class AnalyticsDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> reports = [
    {
      'title': 'Destination Details',
      'icon': Icons.place,
      'page': const PlacesTablePage()
    },
    {
      'title': 'User Messages',
      'icon': Icons.messenger_outlined,
      'page': const UserMessagesTable()
    },
    {
      'title': 'Tourist Profile',
      'icon': Icons.tour_outlined,
      'page': const TourismDataTablePage()
    },
    {
      'title': 'Tourist Statistics',
      'icon': Icons.analytics_sharp,
      'page': const ImageGalleryPage()
    },
    {
      'title': 'Data Collection',
      'icon': Icons.data_exploration_sharp,
      'page': const CoordinatesTablePage()
    },
    {
      'title': 'User Behaviour',
      'icon': Icons.man_3_sharp,
      'page': const UserBehaviour(
        title: '',
        content: '',
      )
    },
    {
      'title': 'Travel Clustering',
      'icon': Icons.groups_2,
      'page': KMeansPage()
    },
    {
      'title': 'Similarity Clustering',
      'icon': Icons.transfer_within_a_station_outlined,
      'page': MovementSimilarityPage()
    },
  ];

  AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Analytics Dashboard'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => reports[index]['page']),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(reports[index]['icon'], size: 50, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(reports[index]['title'],
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReportPage extends StatelessWidget {
  final int reportNumber;
  const ReportPage(this.reportNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report $reportNumber')),
      body: Center(
        child: Text('Details of Report $reportNumber',
            style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnalyticsDashboard(),
  ));
}
