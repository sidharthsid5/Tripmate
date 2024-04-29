import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:keralatour/pallete.dart';
import 'package:provider/provider.dart';

class ScheduleHistory extends StatefulWidget {
  const ScheduleHistory({Key? key}) : super(key: key);

  @override
  State<ScheduleHistory> createState() => _ScheduleHistoryState();
}

class _ScheduleHistoryState extends State<ScheduleHistory> {
  late Future<List<TourScheduleList>> futurescheduleHistory;

  @override
  void initState() {
    super.initState();
    futurescheduleHistory = Provider.of<UserProvider>(context, listen: false)
        .getTourSchedulesHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TourScheduleList>>(
      future: futurescheduleHistory,
      builder: (context, snapshot) {
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
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              // Access tour schedule data from snapshot
              final scheduleHistory = snapshot.data![index];
              return Card(
                elevation: 2,
                color: Pallete.green, // Use color instead of surfaceTintColor
                shadowColor: Pallete.backgroundColor,
                child: ListTile(
                  leading: const Text(
                      ''), // You can put an icon or any other leading widget here
                  title: Text(scheduleHistory.location),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Distance: ${scheduleHistory.distance.toStringAsFixed(2)} km'),
                      Text('Category: ${scheduleHistory.category}'),
                      Text('Time to explore: ${scheduleHistory.time} Hours'),
                    ],
                  ),
                ),
              );
            },
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        }
      },
    );
  }
}

class TourScheduleList {
  final int id;
  final String location;
  final double distance;
  final int time;
  final String category;
  TourScheduleList(
      {required this.id,
      required this.location,
      required this.distance,
      required this.time,
      required this.category});

  factory TourScheduleList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return TourScheduleList(
      id: json['id'] ?? 0, // Provide a default value or handle appropriately
      location: json['location'] ??
          'nothing', // Provide a default value or handle appropriately
      distance: json['distance'] != null
          ? double.parse(json['distance'].toString())
          : 0.0, // Provide a default value or handle appropriately
      time: json['time'] ?? 0,
      category: json['category'] ?? 'Nil',
    );
  }
}
