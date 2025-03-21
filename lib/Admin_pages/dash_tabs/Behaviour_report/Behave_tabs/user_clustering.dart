import 'package:flutter/material.dart';

import 'package:keralatour/Controller/user_controller.dart';

import 'package:keralatour/Widgets/custon_appbar.dart';

import 'package:provider/provider.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:math';

// Model for coordinates

class CoordinatesData5 {
  final int coordinateId;

  final String uid;

  final String date;

  final String time;

  final double longitude;

  final double latitude;

  CoordinatesData5({
    required this.coordinateId,
    required this.uid,
    required this.date,
    required this.time,
    required this.longitude,
    required this.latitude,
  });

  factory CoordinatesData5.fromJson(Map<String, dynamic> json) {
    return CoordinatesData5(
      coordinateId: json['coordinate_id'],
      uid: json['uid'],
      date: json['date'],
      time: json['time'],
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
    );
  }
}

class KMeansPage extends StatefulWidget {
  @override
  _KMeansPageState createState() => _KMeansPageState();
}

class _KMeansPageState extends State<KMeansPage> {
  int k = 3;

  List<List<CoordinatesData5>> clusters = [];

  List<CoordinatesData5> centroids = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchCoordinatesTable2();
    });
  }

  void _performKMeans(List<CoordinatesData5> data) {
    if (data.isEmpty) {
      setState(() {
        clusters = [];

        centroids = [];
      });

      return;
    }

    final random = Random();

    centroids = List.generate(k, (_) => data[random.nextInt(data.length)]);

    List<List<CoordinatesData5>> newClusters = List.generate(k, (_) => []);

    List<List<CoordinatesData5>> previousClusters = [];

    while (!_areClustersEqual(newClusters, previousClusters)) {
      previousClusters =
          newClusters.map((list) => List<CoordinatesData5>.from(list)).toList();

      newClusters = List.generate(k, (_) => []);

      for (var point in data) {
        int closestCentroidIndex = 0;

        double minDistance = double.infinity;

        for (int i = 0; i < k; i++) {
          double distance = _calculateDistance(point, centroids[i]);

          if (distance < minDistance) {
            minDistance = distance;

            closestCentroidIndex = i;
          }
        }

        newClusters[closestCentroidIndex].add(point);
      }

      for (int i = 0; i < k; i++) {
        if (newClusters[i].isNotEmpty) {
          double avgLongitude =
              newClusters[i].map((p) => p.longitude).reduce((a, b) => a + b) /
                  newClusters[i].length;

          double avgLatitude =
              newClusters[i].map((p) => p.latitude).reduce((a, b) => a + b) /
                  newClusters[i].length;

          centroids[i] = CoordinatesData5(
            coordinateId: i, // Just using index as unique id

            uid: "Centroid",

            date: "",

            time: "",

            longitude: avgLongitude,

            latitude: avgLatitude,
          );
        }
      }
    }

    setState(() {
      clusters = newClusters;
    });
  }

  double _calculateDistance(CoordinatesData5 p1, CoordinatesData5 p2) {
    return sqrt(pow(p1.longitude - p2.longitude, 2) +
        pow(p1.latitude - p2.latitude, 2));
  }

  bool _areClustersEqual(
      List<List<CoordinatesData5>> c1, List<List<CoordinatesData5>> c2) {
    if (c1.length != c2.length) return false;

    for (int i = 0; i < c1.length; i++) {
      if (c1[i].length != c2[i].length) return false;

      for (int j = 0; j < c1[i].length; j++) {
        if (c1[i][j].coordinateId != c2[i][j].coordinateId) return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'K-Means Clustering'),
      body: userController.isFetchingCoordinatesTable2
          ? const Center(child: CircularProgressIndicator())
          : userController.coordinatesTable2.isEmpty
              ? const Center(child: Text("No coordinates found."))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Clusters (K): '),
                          DropdownButton<int>(
                            value: k,
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                setState(() => k = newValue);

                                _performKMeans(
                                    userController.coordinatesTable2);
                              }
                            },
                            items: <int>[2, 3, 4, 5]
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                  value: value, child: Text(value.toString()));
                            }).toList(),
                          ),
                          ElevatedButton(
                            onPressed: () => _performKMeans(
                                userController.coordinatesTable2),
                            child: const Text("Run K-Means"),
                          ),
                        ],
                      ),
                    ),
                    clusters.isNotEmpty
                        ? Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 300, // Graph Height

                                  child: charts.ScatterPlotChart(
                                    _createChartData(clusters),
                                    animate: true,
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: 16,
                                        columns: const [
                                          DataColumn(label: Text("Cluster")),
                                          DataColumn(label: Text("Size")),
                                          DataColumn(
                                              label:
                                                  Text("Centroid Longitude")),
                                          DataColumn(
                                              label: Text("Centroid Latitude")),
                                        ],
                                        rows: List.generate(k, (i) {
                                          return DataRow(cells: [
                                            DataCell(Text("Cluster $i")),
                                            DataCell(Text(
                                                clusters[i].length.toString())),
                                            DataCell(Text(centroids[i]
                                                .longitude
                                                .toStringAsFixed(6))),
                                            DataCell(Text(centroids[i]
                                                .latitude
                                                .toStringAsFixed(6))),
                                          ]);
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Center(
                            child: Text("Run K-Means to see clusters.")),
                  ],
                ),
    );
  }

  List<charts.Series<CoordinatesData5, num>> _createChartData(
      List<List<CoordinatesData5>> clusters) {
    List<charts.Color> palette = [
      charts.MaterialPalette.blue.shadeDefault,
      charts.MaterialPalette.red.shadeDefault,
      charts.MaterialPalette.green.shadeDefault,
      charts.MaterialPalette.purple.shadeDefault,
      charts.MaterialPalette.yellow.shadeDefault
    ];

    return clusters.asMap().entries.map((entry) {
      int index = entry.key;

      List<CoordinatesData5> cluster = entry.value;

      return charts.Series<CoordinatesData5, num>(
        id: 'Cluster $index',
        colorFn: (_, __) => palette[index % palette.length],
        domainFn: (point, _) => point.longitude,
        measureFn: (point, _) => point.latitude,
        data: cluster,
      );
    }).toList();
  }
}
