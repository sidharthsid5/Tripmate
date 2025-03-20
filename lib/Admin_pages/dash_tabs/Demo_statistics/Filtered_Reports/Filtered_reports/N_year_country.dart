import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Overall_trends/home_chart.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class YearWiseCountryDistributionPage extends StatefulWidget {
  const YearWiseCountryDistributionPage({super.key});

  @override
  _YearWiseCountryDistributionPageState createState() =>
      _YearWiseCountryDistributionPageState();
}

class _YearWiseCountryDistributionPageState
    extends State<YearWiseCountryDistributionPage> {
  String? selectedYear;
  late Future<List<TouristDetail>> futureTouristDetails;

  @override
  void initState() {
    super.initState();
    futureTouristDetails =
        Provider.of<UserProvider>(context, listen: false).fetchTouristDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Year-wise Country Distribution'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<TouristDetail>>(
          future: futureTouristDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            final years =
                snapshot.data!.map((detail) => detail.year).toSet().toList();

            if (years.isEmpty) {
              return const Center(child: Text('No years available.'));
            }

            return Column(
              children: [
                DropdownButton<String>(
                  hint: const Text('Select Year'),
                  value: selectedYear,
                  items: years.map((String? year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year ?? 'Unknown'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue;
                    });
                  },
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: selectedYear == null
                      ? const Center(child: Text('Please select a year.'))
                      : _buildCountryDistributionChart(
                          snapshot.data!, selectedYear!),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCountryDistributionChart(
      List<TouristDetail> details, String year) {
    // Filter data for the selected year
    final countryGroups = groupBy(
      details.where((detail) => detail.year == year).toList(),
      (TouristDetail detail) => detail.country,
    );

    // Prepare data for the chart
    var countryData = countryGroups.entries
        .map((entry) => CountryGroup<String>(
              entry.key ?? 'Unknown',
              entry.value.length,
              Colors.teal,
            ))
        .toList();

    var seriesCountryGroup = [
      charts.Series<CountryGroup<String>, String>(
        id: 'CountryGroups',
        data: countryData,
        domainFn: (CountryGroup<String> group, _) => group.country,
        measureFn: (CountryGroup<String> group, _) => group.count,
        colorFn: (CountryGroup<String> group, _) =>
            charts.ColorUtil.fromDartColor(group.color),
        labelAccessorFn: (CountryGroup<String> row, _) => '${row.count}',
      ),
    ];

    return charts.BarChart(
      seriesCountryGroup,
      animate: true,
      vertical: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        // Optional: Customize label appearance
        labelAnchor: charts.BarLabelAnchor.end,
        labelPosition: charts.BarLabelPosition.outside,
      ),
    );
  }
}

class CountryGroup<T> {
  final T country;
  final int count;
  final Color color;

  CountryGroup(this.country, this.count, this.color);
}
