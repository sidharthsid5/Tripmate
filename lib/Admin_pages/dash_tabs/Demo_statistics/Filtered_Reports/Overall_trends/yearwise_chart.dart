import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class YearChartPage extends StatelessWidget {
  final List<charts.Series<YearGroup<String>, String>> seriesList;

  const YearChartPage({Key? key, required this.seriesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Year of Visit Distribution'),
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
              'This graph displays the number of tourists visiting each year. '
              'Each bar represents the total count of visitors for a specific year.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class YearGroup<T> {
  final T ageGroup;
  final int count;
  final Color color;

  YearGroup(this.ageGroup, this.count, this.color);
}
