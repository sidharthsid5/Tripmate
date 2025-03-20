// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Old/Schedule/getdata_schedule.dart';
import 'package:keralatour/User_pages/HomePages/Old/Schedule/schedule.dart';
import 'package:keralatour/Widgets/side_navigator.dart';
import 'package:keralatour/Widgets/pallete.dart';
import 'package:provider/provider.dart';

class ScheduleadminHistory extends StatefulWidget {
  final int userId;

  const ScheduleadminHistory({super.key, required this.userId});
  @override
  State<ScheduleadminHistory> createState() => _ScheduleHistoryState();
}

class _ScheduleHistoryState extends State<ScheduleadminHistory> {
  late Future<List<AdminTourScheduleList>> futurescheduleHistory;

  @override
  void initState() {
    super.initState();
    futurescheduleHistory = Provider.of<UserProvider>(context, listen: false)
        .getAdminTourSchedulesHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      drawer: NaviBar(userId: widget.userId),
      body: SingleChildScrollView(
        child: FutureBuilder<List<AdminTourScheduleList>>(
          future: futurescheduleHistory,
          builder:
              (context, AsyncSnapshot<List<AdminTourScheduleList>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(child: Text('No tour schedules available.'));
            } else {
              return Column(
                children: [
                  for (int index = 0; index < snapshot.data!.length; index++)
                    index == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'User Schedules',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 3,
                                color: Colors.lightGreen[50],
                                shadowColor: Pallete.backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: const Icon(Icons.location_on),
                                    title: Text(
                                      'User ID: ${snapshot.data![index].userId}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'From: ${snapshot.data![index].location.toString()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          'Day: ${snapshot.data![index].day.toString()}',
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Center(),
                            ],
                          )
                        : Card(
                            elevation: 2,
                            color: Colors.white,
                            shadowColor: Pallete.backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: const Icon(Icons.location_on),
                                title: Text(
                                  'User ID: ${snapshot.data![index].userId}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'From: ${snapshot.data![index].location.toString()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Day: ${snapshot.data![index].day.toString()}',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                // Removed onTap callback
                              ),
                            ),
                          ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class AdminTourScheduleList {
  final int day;
  final int tourId;
  final int locationId;
  final String location;
  final String date;
  final int userId;

  AdminTourScheduleList({
    required this.day,
    required this.tourId,
    required this.locationId,
    required this.location,
    required this.date,
    required this.userId,
  });

  factory AdminTourScheduleList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return AdminTourScheduleList(
      day: json['DayNumber'] ?? 0,
      locationId: json['LocationID'] ?? 0,
      tourId: json['TourID'] ?? 0,
      location: json['DistrictName'] ?? 'Unknown',
      date: json['Date'] ?? 'Date',
      userId: json['UserID'] ?? 0,
    );
  }
}
