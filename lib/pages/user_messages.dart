import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:provider/provider.dart';
// Adjust this import as per your project structure

class ScheduleHistory extends StatefulWidget {
  const ScheduleHistory({Key? key}) : super(key: key);

  @override
  State<ScheduleHistory> createState() => _ScheduleHistoryState();
}

class _ScheduleHistoryState extends State<ScheduleHistory> {
  late Future<List<SocialMedia>> futurescheduleHistory;

  @override
  void initState() {
    super.initState();
    futurescheduleHistory =
        Provider.of<UserProvider>(context, listen: false).getSocialMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule History'),
      ),
      body: FutureBuilder<List<SocialMedia>>(
        future: futurescheduleHistory,
        builder: (context, AsyncSnapshot<List<SocialMedia>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is being fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error fetching data, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // If there is no data available, display a message
            return Center(child: Text('No tour schedules available.'));
          } else {
            // If data is available, display it in a ListView
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // Access tour schedule data from snapshot
                final scheduleHistory = snapshot.data![index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.trip_origin),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: ${scheduleHistory.user}'),
                        Text('Latitude: ${scheduleHistory.latitude}'),
                        Text('Longitude: ${scheduleHistory.longitude}'),
                        Text('Speed: ${scheduleHistory.speed}'),
                        Text('Time: ${scheduleHistory.time}'),
                        Text('Message: ${scheduleHistory.messages}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SocialMedia {
  //final int id;
  final String latitude;
  final String longitude;
  final String speed;
  final String user;
  final String time;
  final String messages;
  SocialMedia(
      {required this.messages,
      required this.latitude,
      required this.longitude,
      required this.speed,
      required this.user,
      required this.time});

  factory SocialMedia.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return SocialMedia(
      //id: json['loc_id'] ??
      //   0, // Provide a default value or handle appropriately
      latitude: json['Latitude'] ??
          'nothing', // Provide a default value or handle appropriately
      longitude: json['Longitude'] ??
          'nothing', // Provide a default value or handle appropriately
      time: json['Time'] ?? 'Ti',
      user: json['User'] ?? 'Nil',
      speed: json['Speed'] ?? 'speed',

      messages: json['Messages Received'] ?? 'SMS',
    );
  }
}
