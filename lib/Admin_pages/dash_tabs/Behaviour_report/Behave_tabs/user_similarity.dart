import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/user_clustering.dart';

import 'package:keralatour/Controller/user_controller.dart';

import 'package:keralatour/Widgets/custon_appbar.dart';

import 'package:provider/provider.dart';

import 'dart:math';

class MovementSimilarityPage extends StatefulWidget {
  @override
  _MovementSimilarityPageState createState() => _MovementSimilarityPageState();
}

class _MovementSimilarityPageState extends State<MovementSimilarityPage> {
  Map<String, Map<String, double>> similarityMap = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchCoordinatesTable2();
    });
  }

  void _calculateSimilarityBetweenUsers(
      Map<String, List<CoordinatesData5>> userMovements) {
    Map<String, Map<String, double>> tempMap = {};

    List<String> uids = userMovements.keys.toList();

    for (int i = 0; i < uids.length; i++) {
      for (int j = i + 1; j < uids.length; j++) {
        double similarity = _calculateMovementSimilarity(
          userMovements[uids[i]] ?? [],
          userMovements[uids[j]] ?? [],
        );

        tempMap[uids[i]] ??= {};

        tempMap[uids[j]] ??= {};

        tempMap[uids[i]]![uids[j]] = similarity;

        tempMap[uids[j]]![uids[i]] = similarity;
      }
    }

    setState(() {
      similarityMap = tempMap;
    });
  }

  double _calculateMovementSimilarity(
      List<CoordinatesData5> user1, List<CoordinatesData5> user2) {
    if (user1.isEmpty || user2.isEmpty) return 0.0;

    double totalDistance = 0.0;

    int count = min(user1.length, user2.length);

    for (int i = 0; i < count; i++) {
      totalDistance += _haversineDistance(user1[i], user2[i]);
    }

    double averageDistance = totalDistance / count;

    double maxPossibleDistance = 40075.0;

    double similarity = 1.0 - (averageDistance / maxPossibleDistance);

    return (similarity * 100).clamp(0.0, 100.0);
  }

  double _haversineDistance(CoordinatesData5 p1, CoordinatesData5 p2) {
    const double R = 6371;

    double dLat = _degreesToRadians(p2.latitude - p1.latitude);

    double dLon = _degreesToRadians(p2.longitude - p1.longitude);

    double a = pow(sin(dLat / 2), 2) +
        cos(_degreesToRadians(p1.latitude)) *
            cos(_degreesToRadians(p2.latitude)) *
            pow(sin(dLon / 2), 2);

    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserProvider>(context);

    final coordinates = userController.coordinatesTable2;

    Map<String, List<CoordinatesData5>> userMovements = {};

    for (var coord in coordinates) {
      userMovements[coord.uid] ??= [];

      userMovements[coord.uid]!.add(coord);
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'User Movement Similarity'),
      body: userController.isFetchingCoordinatesTable2
          ? const Center(child: CircularProgressIndicator())
          : coordinates.isEmpty
              ? const Center(child: Text("No coordinates found."))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _calculateSimilarityBetweenUsers(userMovements),
                        child: const Text("Calculate Similarities"),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns:
                                _buildTableColumns(userMovements.keys.toList()),
                            rows: _buildTableRows(userMovements.keys.toList()),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: similarityMap.isEmpty
                            ? const Center(
                                child: Text("Calculate to see the chart."))
                            : _buildBarChart(),
                      ),
                    ),
                  ],
                ),
    );
  }

  List<DataColumn> _buildTableColumns(List<String> uids) {
    return [
      const DataColumn(label: Text("UID")),
      ...uids.map((uid) => DataColumn(label: Text(uid))),
    ];
  }

  List<DataRow> _buildTableRows(List<String> uids) {
    return uids.map((uid1) {
      return DataRow(cells: [
        DataCell(Text(uid1)),
        ...uids.map((uid2) {
          double similarity =
              (uid1 == uid2) ? 100.0 : (similarityMap[uid1]?[uid2] ?? 0.0);

          return DataCell(Text("${similarity.toStringAsFixed(2)}%"));
        }),
      ]);
    }).toList();
  }

  Widget _buildBarChart() {
    List<BarChartGroupData> barGroups = [];

    List<String> uids = similarityMap.keys.toList();

    for (int i = 0; i < uids.length; i++) {
      List<double> similarities = similarityMap[uids[i]]?.values.toList() ?? [];

      if (similarities.isEmpty) continue;

      double avgSimilarity =
          similarities.reduce((a, b) => a + b) / similarities.length;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: avgSimilarity, color: Colors.blue, width: 16),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 50,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                int index = value.toInt();

                if (index >= 0 && index < uids.length) {
                  return Text(uids[index],
                      style: const TextStyle(fontSize: 10));
                }

                return const Text("");
              },
              reservedSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
