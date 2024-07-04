import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserBehaviour extends StatelessWidget {
  const UserBehaviour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Behavior Report'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Total Time Spent per District',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                child: BarChart(
                  BarChartData(
                    barGroups: _generateBarChartData(),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          reservedSize: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Number of Visits Over Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                child: LineChart(
                  LineChartData(
                    lineBarsData: _generateLineChartData(),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          reservedSize: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Distribution of Visits per Place',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                child: PieChart(
                  PieChartData(
                    sections: _generatePieChartData(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Heatmap of Trajectory Density',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                child: ScatterChart(
                  ScatterChartData(
                    scatterSpots: _generateScatterChartData(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarChartData() {
    // Example data, replace with your data
    return [
      BarChartGroupData(
          x: 0, barRods: [BarChartRodData(toY: 3000, color: Colors.blue)]),
      BarChartGroupData(
          x: 1, barRods: [BarChartRodData(toY: 2500, color: Colors.blue)]),
      BarChartGroupData(
          x: 2, barRods: [BarChartRodData(toY: 2000, color: Colors.blue)]),
      // Add more groups as needed...
    ];
  }

  List<LineChartBarData> _generateLineChartData() {
    // Example data, replace with your data
    return [
      LineChartBarData(
        spots: [
          const FlSpot(1, 1),
          const FlSpot(2, 1.5),
          const FlSpot(3, 1.4),
          // Add more spots as needed...
        ],
        isCurved: true,
        color: Colors.blue,
      ),
    ];
  }

  List<PieChartSectionData> _generatePieChartData() {
    // Example data, replace with your data
    return [
      PieChartSectionData(color: Colors.blue, value: 20, title: '20%'),
      PieChartSectionData(color: Colors.orange, value: 30, title: '30%'),
      PieChartSectionData(color: Colors.green, value: 50, title: '50%'),
      // Add more sections as needed...
    ];
  }

  List<ScatterSpot> _generateScatterChartData() {
    return [
      ScatterSpot(
        8,
        8,
      ),
      ScatterSpot(
        9,
        9,
      ),
      ScatterSpot(
        10,
        10,
      ),
      // Add more spots as needed...
    ];
  }
}
