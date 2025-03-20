import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/Controller/user_controller.dart';

class PlacesTablePage extends StatelessWidget {
  const PlacesTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Tourist Destination Details',
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.fetchPlacesTable(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No places data found'));
              }

              final places = snapshot.data!;

              return Column(
                children: [
                  const SizedBox(
                      height: 16), // Adds gap between AppBar and Table
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          border: TableBorder.all(
                              color: Color.fromARGB(255, 172, 171, 171),
                              width: 2),
                          headingRowColor: WidgetStateColor.resolveWith(
                              (states) => Color.fromARGB(255, 78, 129, 108)),
                          dataRowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.white),
                          columns: const [
                            DataColumn(
                                label: Text('District',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Location',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Category',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Time',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Latitude',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Longitude',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Image',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Description',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: places.asMap().entries.map((entry) {
                            final place = entry.value;
                            final rowIndex = entry.key;
                            final isEven = rowIndex % 2 == 0;

                            return DataRow(
                              color: WidgetStateColor.resolveWith(
                                (states) => isEven
                                    ? Colors.grey[200]!
                                    : Colors.grey[300]!,
                              ),
                              cells: [
                                DataCell(Text(place.district)),
                                DataCell(Text(place.location)),
                                DataCell(Text(place.category)),
                                DataCell(Text(place.time)),
                                DataCell(Text(place.latitude.toString())),
                                DataCell(Text(place.longitude.toString())),
                                DataCell(Image.network(place.image,
                                    width: 50, height: 50, fit: BoxFit.cover)),
                                DataCell(Text(place.description,
                                    overflow: TextOverflow.ellipsis)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class PlacesData {
  final String district;
  final String location;
  final String category;
  final String time;
  final double latitude;
  final double longitude;
  final String image;
  final String description;

  PlacesData({
    required this.district,
    required this.location,
    required this.category,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.description,
  });

  factory PlacesData.fromJson(Map<String, dynamic> json) {
    return PlacesData(
      district: json['district'].toString(),
      location: json['location'].toString(),
      category: json['category'].toString(),
      time: json['time'].toString(),
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      image: json['image'].toString(),
      description: json['description'].toString(),
    );
  }
}
