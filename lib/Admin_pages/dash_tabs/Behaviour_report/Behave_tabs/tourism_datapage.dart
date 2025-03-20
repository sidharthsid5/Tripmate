import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/Controller/user_controller.dart';

class TourismDataTablePage extends StatefulWidget {
  const TourismDataTablePage({super.key});

  @override
  State<TourismDataTablePage> createState() => _TourismDataTablePageState();
}

class _TourismDataTablePageState extends State<TourismDataTablePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchTourismData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tourist Data'),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.fetchTourismData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tourism data found'));
              }

              final tourismData = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      child: DataTable(
                        border: TableBorder.all(color: Colors.grey),
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.blueGrey),
                        dataRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.blue.shade50),
                        columns: const [
                          DataColumn(
                              label: Text('UserID',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Age',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Sex',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Country',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Year of Visit',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ],
                        rows: tourismData.map((data) {
                          return DataRow(
                            cells: [
                              DataCell(Text(data.userID.toString())),
                              DataCell(Text(data.age.toString())),
                              DataCell(Text(data.sex)),
                              DataCell(Text(data.country)),
                              DataCell(Text(data.yearOfVisit)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TourismData {
  final String userID;
  final String age;
  final String sex;
  final String country;
  final String yearOfVisit;

  TourismData({
    required this.userID,
    required this.age,
    required this.sex,
    required this.country,
    required this.yearOfVisit,
  });

  factory TourismData.fromJson(Map<String, dynamic> json) {
    return TourismData(
      userID: json['UserID'] ?? '',
      age: json['Age'].toString(),
      sex: json['Sex'].toString(),
      country: json['Country'].toString(),
      yearOfVisit: json['Year of Visit'].toString(),
    );
  }
}
