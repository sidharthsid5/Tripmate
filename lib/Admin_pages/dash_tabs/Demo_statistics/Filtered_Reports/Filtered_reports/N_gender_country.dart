import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Overall_trends/home_chart.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CountryWiseGenderPage extends StatefulWidget {
  const CountryWiseGenderPage({Key? key}) : super(key: key);

  @override
  _CountryWiseGenderPageState createState() => _CountryWiseGenderPageState();
}

class _CountryWiseGenderPageState extends State<CountryWiseGenderPage> {
  late Future<List<TouristDetail>> futureTouristDetails;
  List<TouristDetail>? touristDetails;

  String selectedCountry = 'All';
  final List<String> countries = ['All', 'India', 'USA', 'Germany', 'France'];

  @override
  void initState() {
    super.initState();
    futureTouristDetails =
        Provider.of<UserProvider>(context, listen: false).fetchTouristDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Country-wise Gender Distribution'),
      body: FutureBuilder<List<TouristDetail>>(
        future: futureTouristDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            touristDetails = snapshot.data;
            var seriesList = _prepareGenderData(touristDetails);

            return Column(
              children: [
                // Country Dropdown
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCountry = newValue!;
                      });
                    },
                    items:
                        countries.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: const Text("Select Country"),
                  ),
                ),

                // Chart
                Expanded(
                  child: charts.BarChart(
                    seriesList,
                    animate: true,
                    barRendererDecorator: charts.BarLabelDecorator<String>(),
                    domainAxis: const charts.OrdinalAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 12,
                          color: charts.MaterialPalette.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  List<charts.Series<GenderGroup, String>> _prepareGenderData(
      List<TouristDetail>? details) {
    if (details == null) return [];

    Map<String, int> genderCounts = {};

    for (var detail in details) {
      if (selectedCountry == 'All' || detail.country == selectedCountry) {
        genderCounts[detail.sex!] = (genderCounts[detail.sex!] ?? 0) + 1;
      }
    }

    var data = genderCounts.entries.map((entry) {
      return GenderGroup(entry.key, entry.value, Colors.teal);
    }).toList();

    return [
      charts.Series<GenderGroup, String>(
        id: 'GenderData',
        data: data,
        domainFn: (GenderGroup group, _) => group.label,
        measureFn: (GenderGroup group, _) => group.count,
        colorFn: (GenderGroup group, _) =>
            charts.ColorUtil.fromDartColor(group.color),
        labelAccessorFn: (GenderGroup group, _) => '${group.count}',
      ),
    ];
  }
}

class GenderGroup {
  final String label;
  final int count;
  final Color color;

  GenderGroup(this.label, this.count, this.color);
}
