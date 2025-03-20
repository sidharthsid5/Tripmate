import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GenderChartPage extends StatelessWidget {
  final List<charts.Series<GenderGroup<String>, String>> seriesList;

  const GenderChartPage({Key? key, required this.seriesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gender Distribution'),
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
              'This graph shows the distribution of tourists by gender. '
              'It indicates the total count of male and female tourists.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class GenderGroup<T> {
  final T ageGroup;
  final int count;
  final Color color;

  GenderGroup(this.ageGroup, this.count, this.color);
}
