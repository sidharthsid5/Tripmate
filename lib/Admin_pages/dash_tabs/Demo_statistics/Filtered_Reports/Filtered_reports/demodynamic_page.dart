import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Filtered_reports/N_age_by_country.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Filtered_reports/N_gender_country.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Filtered_reports/N_year_country.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';

class NewChartPage extends StatelessWidget {
  const NewChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tourist Details'),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Age Range Distribution'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AgeGroupCountryChart()),
              );
            },
          ),
          ListTile(
            title: const Text('Gender Distribution'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CountryWiseGenderPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Year-wise Distribution'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const YearWiseCountryDistributionPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
