import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Overall_trends/home_chart.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Filtered_reports/demodynamic_page.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';

class StatisticsHomePage extends StatelessWidget {
  const StatisticsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Statistics Overview'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTile(
                  context,
                  'Statistics Filtered Reports',
                  Icons.bar_chart,
                  Colors.blue,
                  const NewChartPage(),
                ),
                _buildTile(
                  context,
                  'Overall Tourist Trends',
                  Icons.insert_chart,
                  Colors.green,
                  const TouristDetailScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon,
      Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
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
