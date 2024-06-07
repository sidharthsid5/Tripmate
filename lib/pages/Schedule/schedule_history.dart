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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule History'),
        backgroundColor: Colors.green, // Customize the app bar color here
      ),
      body: Container(
        color: Colors.white, // Set your desired background color here
        child: FutureBuilder<List<TourScheduleList>>(
          future: futurescheduleHistory,
          builder: (context, AsyncSnapshot<List<TourScheduleList>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While data is being fetched, show a loading indicator
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If there's an error fetching data, display an error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              // If there is no data available, display a message
              return const Center(child: Text('No tour schedules available.'));
            } else {
              // If data is available, display it in a ListView
              return ListView.separated(
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  // Access tour schedule data from snapshot
                  final scheduleHistory = snapshot.data![index];
                  return Card(
                    elevation: 2,
                    shadowColor: Pallete.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.green, // Border color
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const Icon(Icons.location_on), // Icon
                        title: Text('Trip: ${scheduleHistory.tourId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location: ${scheduleHistory.location.toString()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Day: ${scheduleHistory.day.toString()}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            // Add more fields here if needed
                          ],
                        ),
                        trailing: const Icon(
                            Icons.arrow_forward_ios), // Trailing icon
                        onTap: () {
                          // Handle tap on ListTile if needed
                        },
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              );
            }
          },
        ),
      ),
    );
  }
}

class TourScheduleList {
  final int day;
  final int tourId;
  final int location;

  TourScheduleList({
    required this.day,
    required this.tourId,
    required this.location,
  });

  factory TourScheduleList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return TourScheduleList(
      day: json['DayNumber'] ?? 0,
      location: json['LocationID'] ?? 0, // Change to integer parsing
      tourId: json['TourId'] ?? 0,
    );
  }
}
