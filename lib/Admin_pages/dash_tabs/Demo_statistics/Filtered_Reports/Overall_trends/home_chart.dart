import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Overall_trends/age_chart.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Overall_trends/gender_chart.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Overall_trends/yearwise_chart.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'country_chart_page.dart';

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
      appBar: const CustomAppBar(title: 'Tourist Details'),
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
                    final countryGroups = groupBy(snapshot.data!,
                        (TouristDetail detail) => detail.country);

                    int maleCount = snapshot.data!
                        .where((detail) => detail.sex == 'M')
                        .length;
                    int femaleCount = snapshot.data!
                        .where((detail) => detail.sex == 'F')
                        .length;

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

                    final yearGroups = groupBy(
                        snapshot.data!, (TouristDetail detail) => detail.year);

                    var ageGroupData = [
                      AgeGroup<String>('0-25', age0to25Count, Colors.blue),
                      AgeGroup<String>('26-45', age26to45Count, Colors.green),
                      AgeGroup<String>('46-60', age46to60Count, Colors.orange),
                      AgeGroup<String>('61-100', age61to100Count, Colors.red),
                    ];

                    var yearGroupData = yearGroups.entries
                        .map((entry) => YearGroup<String>(
                            entry.key ?? 'Unknown',
                            entry.value.length,
                            Colors.purple))
                        .toList();

                    var genderData = [
                      GenderGroup<String>('Male', maleCount, Colors.blue),
                      GenderGroup<String>('Female', femaleCount, Colors.pink),
                    ];

                    var countryData = countryGroups.entries
                        .map((entry) => CountryGroup<String>(
                            entry.key ?? 'Unknown',
                            entry.value.length,
                            Colors.teal))
                        .toList();

                    var seriesAgeGroup = [
                      charts.Series<AgeGroup<String>, String>(
                        id: 'AgeGroups',
                        data: ageGroupData,
                        domainFn: (AgeGroup<String> group, _) => group.ageGroup,
                        measureFn: (AgeGroup<String> group, _) => group.count,
                        colorFn: (AgeGroup<String> group, _) =>
                            charts.ColorUtil.fromDartColor(group.color),
                      ),
                    ];

                    var seriesYearGroup = [
                      charts.Series<YearGroup<String>, String>(
                        id: 'YearGroups',
                        data: yearGroupData,
                        domainFn: (YearGroup<String> group, _) =>
                            group.ageGroup,
                        measureFn: (YearGroup<String> group, _) => group.count,
                        colorFn: (YearGroup<String> group, _) =>
                            charts.ColorUtil.fromDartColor(group.color),
                      ),
                    ];

                    var seriesGenderGroup = [
                      charts.Series<GenderGroup<String>, String>(
                        id: 'GenderGroups',
                        data: genderData,
                        domainFn: (GenderGroup<String> group, _) =>
                            group.ageGroup,
                        measureFn: (GenderGroup<String> group, _) =>
                            group.count,
                        colorFn: (GenderGroup<String> group, _) =>
                            charts.ColorUtil.fromDartColor(group.color),
                      ),
                    ];

                    var seriesCountryGroup = [
                      charts.Series<CountryGroup<String>, String>(
                        id: 'CountryGroups',
                        data: countryData,
                        domainFn: (CountryGroup<String> group, _) =>
                            group.ageGroup,
                        measureFn: (CountryGroup<String> group, _) =>
                            group.count,
                        colorFn: (CountryGroup<String> group, _) =>
                            charts.ColorUtil.fromDartColor(group.color),
                      ),
                    ];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          title: const Text('Age Range Distribution'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AgeChartPage(
                                  seriesList: seriesAgeGroup,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Year of Visit Distribution'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => YearChartPage(
                                  seriesList: seriesYearGroup,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Gender Distribution'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenderChartPage(
                                  seriesList: seriesGenderGroup,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Country Distribution'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountryChartPage(
                                  seriesList: seriesCountryGroup,
                                ),
                              ),
                            );
                          },
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

class AgeGroup<T> {
  final T ageGroup;
  final int count;
  final Color color;

  AgeGroup(this.ageGroup, this.count, this.color);

  get ageRange => null;

  get age => null;

  get groupLabel => null;
}
