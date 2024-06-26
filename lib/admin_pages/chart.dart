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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            FutureBuilder<List<TouristDetail>>(
              future: futureTouristDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Grouping by country and counting users for each country
                  final countryGroups = groupBy(
                      snapshot.data!, (TouristDetail detail) => detail.country);

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
                      .where(
                          (detail) => _calculateAgeRange(detail.age!) == '0-25')
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

                  // Building a list of Text widgets to display country counts
                  final countryCountWidgets = countryGroups.entries
                      .map((entry) =>
                          Text('${entry.key}: ${entry.value.length}'))
                      .toList();

                  // Building a list of Text widgets to display year counts
                  final yearCountWidgets = yearGroups.entries
                      .map((entry) =>
                          Text('${entry.key}: ${entry.value.length}'))
                      .toList();

                  // Data for bar chart
                  var ageGroupData = [
                    AgeGroup('0-25', age0to25Count, Colors.blue),
                    AgeGroup('26-45', age26to45Count, Colors.green),
                    AgeGroup('46-60', age46to60Count, Colors.orange),
                    AgeGroup('61-100', age61to100Count, Colors.red),
                  ];

                  var series = [
                    charts.Series(
                      id: 'AgeGroups',
                      data: ageGroupData,
                      domainFn: (AgeGroup group, _) => group.ageGroup,
                      measureFn: (AgeGroup group, _) => group.count,
                      colorFn: (AgeGroup group, _) =>
                          charts.ColorUtil.fromDartColor(group.color),
                    )
                  ];

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Total Users: $totalCount'),
                        Text('Male Users: $maleCount'),
                        Text('Female Users: $femaleCount'),
                        const SizedBox(height: 10.0),
                        Text('Count of Users by Country:'),
                        const SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: countryCountWidgets,
                        ),
                        const SizedBox(height: 10.0),
                        Text('Count of Users by Age Range:'),
                        const SizedBox(height: 10.0),
                        Text('0-25 years: $age0to25Count'),
                        Text('26-45 years: $age26to45Count'),
                        Text('46-60 years: $age46to60Count'),
                        Text('61-100 years: $age61to100Count'),
                        const SizedBox(height: 10.0),
                        Text('Count of Users by Visit Year:'),
                        const SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: yearCountWidgets,
                        ),
                        const SizedBox(height: 20.0),
                        Text('Age Range Distribution:'),
                        AspectRatio(
                          aspectRatio: 1.5,
                          child: charts.BarChart(
                            series,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              renderSpec: charts.GridlineRendererSpec(
                                labelStyle: const charts.TextStyleSpec(
                                  fontSize: 12,
                                  color: charts.MaterialPalette.black,
                                ),
                                lineStyle: charts.LineStyleSpec(
                                  color:
                                      charts.MaterialPalette.gray.shadeDefault,
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
                                  color:
                                      charts.MaterialPalette.gray.shadeDefault,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
