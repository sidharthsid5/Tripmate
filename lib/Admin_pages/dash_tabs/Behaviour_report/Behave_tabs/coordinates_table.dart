import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/Controller/user_controller.dart';

class CoordinatesTablePage extends StatefulWidget {
  const CoordinatesTablePage({super.key});

  @override
  State<CoordinatesTablePage> createState() => _CoordinatesTablePageState();
}

class _CoordinatesTablePageState extends State<CoordinatesTablePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchCoordinatesTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Collected Travel Data'),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isFetchingCoordinatesTable) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.coordinatesTable.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enables horizontal scrolling
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Enables vertical scrolling
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade400),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                    3: IntrinsicColumnWidth(),
                    4: IntrinsicColumnWidth(),
                  },
                  children: [
                    // Table Header
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: const [
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('UID',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('Date',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('Time',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('Latitude',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('Longitude',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        )),
                      ],
                    ),
                    // Table Rows
                    ...provider.coordinatesTable.map((coord) {
                      return TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(coord.uid.toString())),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(coord.date)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(coord.time)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Center(child: Text(coord.latitude.toString())),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Center(child: Text(coord.longitude.toString())),
                          )),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CoordinatesData {
  final int uid;
  final String date;
  final String time;
  final double latitude;
  final double longitude;

  CoordinatesData(
      {required this.uid,
      required this.date,
      required this.time,
      required this.latitude,
      required this.longitude});

  factory CoordinatesData.fromJson(Map<String, dynamic> json) {
    return CoordinatesData(
      uid: int.tryParse(json['uid'].toString()) ?? 0, // Convert to int safely
      date: json['date'].toString(),
      time: json['time'].toString(),
      latitude: double.tryParse(json['latitude'].toString()) ??
          0.0, // Convert to double safely
      longitude: double.tryParse(json['longitude'].toString()) ??
          0.0, // Convert to double safely
    );
  }
}
