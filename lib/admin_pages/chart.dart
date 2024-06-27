import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart'; // Adjust this import based on your actual file structure
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TouristDetailScreen extends StatefulWidget {
  const TouristDetailScreen({Key? key}) : super(key: key);

  @override
  _TouristDetailScreenState createState() => _TouristDetailScreenState();
}

class _TouristDetailScreenState extends State<TouristDetailScreen> {
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
      appBar: AppBar(
        title: Text('Tourist Details'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10.0),
              FutureBuilder<List<TouristDetail>>(
                future: futureTouristDetails,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Grouping by country and counting users for each country
                    final countryGroups = groupBy(snapshot.data!,
                        (TouristDetail detail) => detail.country);

                    // Calculating total count of users
                    int totalCount = snapshot.data!.length;

                    // Calculating count of males and females
                    int maleCount = snapshot.data!
                        .where((detail) => detail.sex == 'M')
                        .length;
                    int femaleCount = snapshot.data!
                        .where((detail) => detail.sex == 'F')
                        .length;

                    // Calculating count of users in age ranges
                    int age0to25Count = snapshot.data!
                        .where((detail) =>
                            _calculateAgeRange(detail.age!) == '0-25')
                        .length;
                    int age26to45Count = snapshot.data!
                        .where((detail) =>
                            _calculateAgeRange(detail.age!) == '26-45')
                        .length;
                    int age46to60Count = snapshot.data!
                        .where((detail) =>
                            _calculateAgeRange(detail.age!) == '46-60')
                        .length;
                    int age61to100Count = snapshot.data!
                        .where((detail) =>
                            _calculateAgeRange(detail.age!) == '61-100')
                        .length;

                    // Grouping by year of visit and counting users for each year
                    final yearGroups = groupBy(
                        snapshot.data!, (TouristDetail detail) => detail.year);

                    // Data for bar chart for age range
                    var ageGroupData = [
                      AgeGroup('0-25', age0to25Count, Colors.blue),
                      AgeGroup('26-45', age26to45Count, Colors.green),
                      AgeGroup('46-60', age46to60Count, Colors.orange),
                      AgeGroup('61-100', age61to100Count, Colors.red),
                    ];

                    // Data for bar chart for year
                    var yearGroupData = yearGroups.entries
                        .map((entry) => AgeGroup(entry.key ?? 'Unknown',
                            entry.value.length, Colors.purple))
                        .toList();

                    // Data for bar chart for gender
                    var genderData = [
                      AgeGroup('Male', maleCount, Colors.blue),
                      AgeGroup('Female', femaleCount, Colors.pink),
                    ];

                    // Data for bar chart for country
                    var countryData = countryGroups.entries
                        .map((entry) => AgeGroup(entry.key ?? 'Unknown',
                            entry.value.length, Colors.teal))
                        .toList();

                    var seriesAgeGroup = [
                      charts.Series(
                        id: 'AgeGroups',
                        data: ageGroupData,
                        domainFn: (AgeGroup group, _) => group.ageGroup,
                        measureFn: (AgeGroup group, _) => group.count,
                        colorFn: (AgeGroup group, _) =>
                            charts.ColorUtil.fromDartColor(group.color),
                      ),
                    ];

                    var seriesYearGroup = [
                      charts.Series(
                        id: 'YearGroups',
                        data: yearGroupData,
                        domainFn: (AgeGroup group, _) => group.ageGroup,
                        measureFn: (AgeGroup group, _) => group.count,
                        colorFn: (AgeGroup group, _) =>
                            charts.ColorUtil.fromDartColor(group.color),
                      ),
                    ];

                    var seriesGenderGroup = [
                      charts.Series(
                        id: 'GenderGroups',
                        data: genderData,
                        domainFn: (AgeGroup group, _) => group.ageGroup,
                        measureFn: (AgeGroup group, _) => group.count,
                        colorFn: (AgeGroup group, _) =>
                            charts.ColorUtil.fromDartColor(group.color),
                      ),
                    ];

                    var seriesCountryGroup = [
                      charts.Series(
                        id: 'CountryGroups',
                        data: countryData,
                        domainFn: (AgeGroup group, _) => group.ageGroup,
                        measureFn: (AgeGroup group, _) => group.count,
                        colorFn: (AgeGroup group, _) =>
                            charts.ColorUtil.fromDartColor(group.color),
                      ),
                    ];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ExpansionTile(
                          title: Text('Age Range Distribution'),
                          children: [
                            AspectRatio(
                              aspectRatio: 1.5,
                              child: charts.BarChart(
                                seriesAgeGroup,
                                animate: true,
                                barGroupingType: charts.BarGroupingType.grouped,
                                primaryMeasureAxis: charts.NumericAxisSpec(
                                  renderSpec: charts.GridlineRendererSpec(
                                    labelStyle: const charts.TextStyleSpec(
                                      fontSize: 12,
                                      color: charts.MaterialPalette.black,
                                    ),
                                    lineStyle: charts.LineStyleSpec(
                                      color: charts
                                          .MaterialPalette.gray.shadeDefault,
                                    ),
                                  ),
                                ),
                                domainAxis: charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                    labelStyle: const charts.TextStyleSpec(
                                      fontSize: 12,
                                      color: charts.MaterialPalette.black,
                                    ),
                                    lineStyle: charts.LineStyleSpec(
                                      color: charts
                                          .MaterialPalette.gray.shadeDefault,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'This graph shows the distribution of tourists based on their age ranges. '
                                'The age ranges are divided into four groups: 0-25, 26-45, 46-60, and 61-100.',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Year of Visit Distribution'),
                          children: [
                            AspectRatio(
                              aspectRatio: 1.5,
                              child: charts.BarChart(
                                seriesYearGroup,
                                animate: true,
                                barGroupingType: charts.BarGroupingType.grouped,
                                primaryMeasureAxis: charts.NumericAxisSpec(
                                  renderSpec: charts.GridlineRendererSpec(
                                    labelStyle: const charts.TextStyleSpec(
                                      fontSize: 12,
                                      color: charts.MaterialPalette.black,
                                    ),
                                    lineStyle: charts.LineStyleSpec(
                                      color: charts
                                          .MaterialPalette.gray.shadeDefault,
                                    ),
                                  ),
                                ),
                                domainAxis: charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                    labelStyle: const charts.TextStyleSpec(
                                      fontSize: 12,
                                      color: charts.MaterialPalette.black,
                                    ),
                                    lineStyle: charts.LineStyleSpec(
                                      color: charts
                                          .MaterialPalette.gray.shadeDefault,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'This graph displays the number of tourists visiting each year. '
                                'Each bar represents the total count of visitors for a specific year.',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Gender Distribution'),
                          children: [
                            AspectRatio(
                              aspectRatio: 1.5,
                              child: charts.BarChart(
                                seriesGenderGroup,
                                animate: true,
                                barGroupingType: charts.BarGroupingType.grouped,
                                primaryMeasureAxis: charts.NumericAxisSpec(
                                  renderSpec: charts.GridlineRendererSpec(
                                    labelStyle: const charts.TextStyleSpec(
                                      fontSize: 12,
                                      color: charts.MaterialPalette.black,
                                    ),
                                    lineStyle: charts.LineStyleSpec(
                                      color: charts
                                          .MaterialPalette.gray.shadeDefault,
                                    ),
                                  ),
                                ),
                                domainAxis: charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                    labelStyle: const charts.TextStyleSpec(
                                      fontSize: 12,
                                      color: charts.MaterialPalette.black,
                                    ),
                                    lineStyle: charts.LineStyleSpec(
                                      color: charts
                                          .MaterialPalette.gray.shadeDefault,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'This graph shows the distribution of tourists by gender. '
                                'It indicates the total count of male and female tourists.',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Country Distribution'),
                          children: [
                            AspectRatio(
                              aspectRatio: 1.5,
                              child: charts.BarChart(
                                seriesCountryGroup,
                                animate: true,
                                barGroupingType: charts.BarGroupingType.grouped,
                                primaryMeasureAxis: charts.NumericAxisSpec(
                                  renderSpec: charts.GridlineRendererSpec(
                                    labelStyle: const charts.TextStyleSpec(
                                      fontSize: 12,
                                      color: charts.MaterialPalette.black,
                                    ),
                                    lineStyle: charts.LineStyleSpec(
                                      color: charts
                                          .MaterialPalette.gray.shadeDefault,
                                    ),
                                  ),
                                ),
                                domainAxis: charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                    labelStyle: const charts.TextStyleSpec(
                                      fontSize: 12,
                                      color: charts.MaterialPalette.black,
                                    ),
                                    lineStyle: charts.LineStyleSpec(
                                      color: charts
                                          .MaterialPalette.gray.shadeDefault,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'This graph displays the number of tourists from different countries. '
                                'Each bar represents the total count of visitors from a specific country.',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to calculate age range based on age
  String _calculateAgeRange(String? age) {
    if (age != null) {
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
    }
    return 'Unknown';
  }
}

class TouristDetail {
  final String? age;
  final String? userid;
  final String? country;
  final String? sex;
  final String? year;

  TouristDetail(this.age, this.userid, this.country, this.sex, this.year);

  factory TouristDetail.fromJson(Map<String, dynamic> json) {
    return TouristDetail(
      json['Age'],
      json['UserID'],
      json['Country'],
      json['Sex'],
      json['Year of Visit'],
    );
  }
}

class AgeGroup {
  final String ageGroup;
  final int count;
  final Color color;

  AgeGroup(this.ageGroup, this.count, this.color);
}
