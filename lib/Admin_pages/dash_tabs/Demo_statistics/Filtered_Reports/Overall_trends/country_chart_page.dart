import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CountryChartPage extends StatelessWidget {
  final List<charts.Series<CountryGroup<String>, String>> seriesList;

  const CountryChartPage({Key? key, required this.seriesList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Distribution'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: charts.BarChart(
              seriesList,
              animate: true,
              barGroupingType: charts.BarGroupingType.grouped,
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: const charts.TextStyleSpec(
                    fontSize: 12,
                    color: charts.MaterialPalette.black,
                  ),
                  lineStyle: charts.LineStyleSpec(
                    color: charts.MaterialPalette.gray.shadeDefault,
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
                    color: charts.MaterialPalette.gray.shadeDefault,
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
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class CountryGroup<T> {
  final T ageGroup;
  final int count;
  final Color color;

  CountryGroup(this.ageGroup, this.count, this.color);
}
