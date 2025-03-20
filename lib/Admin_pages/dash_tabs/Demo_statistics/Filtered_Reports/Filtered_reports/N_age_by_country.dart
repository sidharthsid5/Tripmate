import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Overall_trends/home_chart.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';

class AgeGroupCountryChart extends StatefulWidget {
  const AgeGroupCountryChart({Key? key}) : super(key: key);

  @override
  _AgeGroupCountryChartState createState() => _AgeGroupCountryChartState();
}

class _AgeGroupCountryChartState extends State<AgeGroupCountryChart> {
  late Future<List<TouristDetail>> futureTouristDetails;
  List<TouristDetail>? touristDetails;

  // Dropdown filter value
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
      appBar: const CustomAppBar(title: 'Country-wise Age Distribution'),
      body: FutureBuilder<List<TouristDetail>>(
        future: futureTouristDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            touristDetails = snapshot.data;
            var seriesList = _prepareData(touristDetails);

            return Column(
              children: [
                // Country Dropdown
                DropdownButton<String>(
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

                // Chart to display the filtered data
                Expanded(
                  child: charts.BarChart(
                    seriesList,
                    animate: true,
                    barRendererDecorator: charts.BarLabelDecorator<String>(),
                    domainAxis: const charts.OrdinalAxisSpec(
                      showAxisLine: true,
                      renderSpec: charts.SmallTickRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 12,
                          color: charts.MaterialPalette.black,
                        ),
                        labelRotation: 45,
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

  List<charts.Series<dynamic, String>> _prepareData(
      List<TouristDetail>? details) {
    if (details == null) return [];

    Map<String, int> ageGroups = {
      '0-25': 0,
      '26-45': 0,
      '46-60': 0,
      '61-100': 0
    };

    for (var detail in details) {
      if (selectedCountry != 'All' && detail.country != selectedCountry) {
        continue;
      }

      String ageRange = _calculateAgeRange(detail.age!);
      ageGroups[ageRange] = (ageGroups[ageRange] ?? 0) + 1;
    }

    var data = ageGroups.entries.map((entry) {
      return AgeGroup(entry.key, entry.value);
    }).toList();

    return [
      charts.Series<AgeGroup, String>(
        id: 'AgeGroupData',
        data: data,
        domainFn: (AgeGroup group, _) => group.ageRange,
        measureFn: (AgeGroup group, _) => group.count,
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        labelAccessorFn: (AgeGroup group, _) => '${group.count}',
      ),
    ];
  }

  String _calculateAgeRange(String age) {
    int ageInt = int.tryParse(age) ?? 0;
    if (ageInt >= 0 && ageInt <= 25) {
      return '0-25';
    } else if (ageInt >= 26 && ageInt <= 45) {
      return '26-45';
    } else if (ageInt >= 46 && ageInt <= 60) {
      return '46-60';
    } else if (ageInt >= 61 && ageInt <= 100) {
      return '61-100';
    }
    return 'Unknown';
  }
}

class AgeGroup {
  final String ageRange;
  final int count;

  AgeGroup(this.ageRange, this.count);
}
