// import 'package:flutter/material.dart';

// class PlacesList extends StatelessWidget {
//   final List<Map<String, dynamic>> sortedPlaces; // List of sorted places

//   const PlacesList(this.sortedPlaces, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: sortedPlaces.length,
//       itemBuilder: (BuildContext context, int index) {
//         final place = sortedPlaces[index];
//         final placeName = place['location'];
//         final distance = place['distance'];

//         return ListTile(
//           title: Text(placeName),
//           subtitle: Text(
//               '${distance.toStringAsFixed(2)} km'), // Format distance to 2 decimal places
//         );
//       },
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SortedPlacesPage extends StatefulWidget {
  final String currentLocation;
  final int days;

  const SortedPlacesPage(
      {super.key, required this.currentLocation, required this.days});

  @override
  _SortedPlacesPageState createState() => _SortedPlacesPageState();
}

class _SortedPlacesPageState extends State<SortedPlacesPage> {
  List<dynamic> sortedPlaces = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse('http://10.11.2.236:4000/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode({'location': widget.currentLocation, 'days': widget.days}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        sortedPlaces = data['sortedPlaces'];
      });
    } else {
      // Handle error
      print('Failed to load sorted places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorted Places'),
      ),
      body: ListView.builder(
        itemCount: sortedPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          final place = sortedPlaces[index];
          return ListTile(
            title: Text(place['location']),
            subtitle: Text('${place['distance'].toStringAsFixed(2)} km'),
          );
        },
      ),
    );
  }
}
