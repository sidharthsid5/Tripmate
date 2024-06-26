import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AllGraph extends StatefulWidget {
  const AllGraph({super.key});

  @override
  State<AllGraph> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<AllGraph> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Professional Chart Example'),
        ),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Male to Female Ratio',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(8.0),
              child: const MaleFemaleRatioChart(),
            ),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Age Groups',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(8.0),
              child: const AgeGroupChart(),
            ),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Country Distribution',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(8.0),
              child: const CountryDistributionChart(),
            ),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Total Users Per Year',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(8.0),
              child: const TotalUsersPerYearChart(),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class MaleFemaleRatioChart extends StatelessWidget {
  const MaleFemaleRatioChart({super.key});

  @override
  Widget build(BuildContext context) {
    var data = [
      Ratio('Male', 0.4, Colors.blueAccent),
      Ratio('Female', 0.5, Colors.pink),
    ];

    var series = [
      charts.Series(
        id: 'Ratio',
        data: data,
        domainFn: (Ratio ratio, _) => ratio.gender,
        measureFn: (Ratio ratio, _) => ratio.ratio,
        colorFn: (Ratio ratio, _) =>
            charts.ColorUtil.fromDartColor(ratio.color),
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: const charts.TextStyleSpec(
              fontSize: 12, color: charts.MaterialPalette.black),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: const charts.TextStyleSpec(
              fontSize: 12, color: charts.MaterialPalette.black),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
    );
  }
}

class AgeGroupChart extends StatelessWidget {
  const AgeGroupChart({super.key});

  @override
  Widget build(BuildContext context) {
    var data = [
      AgeGroup('20-40', 92, Colors.green),
      AgeGroup('40-60', 75, Colors.yellow),
      AgeGroup('60+', 40, Colors.red),
    ];

    var series = [
      charts.Series(
        id: 'AgeGroups',
        data: data,
        domainFn: (AgeGroup group, _) => group.ageGroup,
        measureFn: (AgeGroup group, _) => group.count,
        colorFn: (AgeGroup group, _) =>
            charts.ColorUtil.fromDartColor(group.color),
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: const charts.TextStyleSpec(
              fontSize: 12, color: charts.MaterialPalette.black),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: const charts.TextStyleSpec(
              fontSize: 12, color: charts.MaterialPalette.black),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
    );
  }
}

class CountryDistributionChart extends StatelessWidget {
  const CountryDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    var data = [
      CountryDistribution('Australia', 17.2, Colors.blue),
      CountryDistribution('USA', 16.0, Colors.green),
      CountryDistribution('Canada', 14.0, Colors.red),
      CountryDistribution('France', 12.0, Colors.yellow),
      CountryDistribution('India', 11.6, Colors.purple),
      CountryDistribution('UK', 10.4, Colors.orange),
      CountryDistribution('Germany', 18.8, Colors.cyan),
    ];

    var series = [
      charts.Series(
        id: 'CountryDistribution',
        data: data,
        domainFn: (CountryDistribution country, _) => country.country,
        measureFn: (CountryDistribution country, _) => country.percentage,
        colorFn: (CountryDistribution country, _) =>
            charts.ColorUtil.fromDartColor(country.color),
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: const charts.TextStyleSpec(
              fontSize: 12, color: charts.MaterialPalette.black),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: const charts.TextStyleSpec(
              fontSize: 12, color: charts.MaterialPalette.black),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
    );
  }
}

class TotalUsersPerYearChart extends StatelessWidget {
  const TotalUsersPerYearChart({super.key});

  @override
  Widget build(BuildContext context) {
    var data = [
      TotalUsersPerYear('2019', 10, Colors.blue),
      TotalUsersPerYear('2020', 20, Colors.green),
      TotalUsersPerYear('2021', 25, Colors.red),
      TotalUsersPerYear('2022', 30, Colors.yellow),
      TotalUsersPerYear('2023', 40, Colors.purple),
      TotalUsersPerYear('2024', 45, Colors.blue),
    ];

    var series = [
      charts.Series(
        id: 'TotalUsersPerYear',
        data: data,
        domainFn: (TotalUsersPerYear users, _) => users.year,
        measureFn: (TotalUsersPerYear users, _) => users.count,
        colorFn: (TotalUsersPerYear users, _) =>
            charts.ColorUtil.fromDartColor(users.color),
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: const charts.TextStyleSpec(
              fontSize: 12, color: charts.MaterialPalette.black),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: const charts.TextStyleSpec(
              fontSize: 12, color: charts.MaterialPalette.black),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
    );
  }
}

class Ratio {
  final String gender;
  final double ratio;
  final Color color;

  Ratio(this.gender, this.ratio, this.color);
}

class AgeGroup {
  final String ageGroup;
  final int count;
  final Color color;

  AgeGroup(this.ageGroup, this.count, this.color);
}

class CountryDistribution {
  final String country;
  final double percentage;
  final Color color;

  CountryDistribution(this.country, this.percentage, this.color);
}

class TotalUsersPerYear {
  final String year;
  final int count;
  final Color color;

  TotalUsersPerYear(this.year, this.count, this.color);
}
