import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Schedule/schedule.dart';
import 'package:keralatour/Widgets/bottom_navigation.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:keralatour/Widgets/floating_action.dart';
import 'package:keralatour/Widgets/left_navigator.dart';
import 'package:keralatour/Widgets/pallete.dart';
import 'package:provider/provider.dart';

class ScheduleHistory extends StatefulWidget {
  final int userId; // Add userId parameter

  const ScheduleHistory({Key? key, required this.userId}) : super(key: key);

  @override
  State<ScheduleHistory> createState() => _ScheduleHistoryState();
}

class _ScheduleHistoryState extends State<ScheduleHistory> {
  late Future<List<TourScheduleList>> futurescheduleHistory;
  int _currentIndex = 0;
  bool addSchedule = false;
  @override
  void initState() {
    super.initState();
    futurescheduleHistory = Provider.of<UserProvider>(context, listen: false)
        .getTourSchedulesHistory(widget.userId); // Pass userId to fetch data
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addSchedule(int userId) {
    setState(() {
      addSchedule = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tourism'),
      drawer: NaviBar(userId: widget.userId),
      bottomNavigationBar: TourBottomNavigator(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: CustomFloatingActionButton(
        userId: widget.userId,
        onAddSchedule: _addSchedule,
      ),
      body: Container(
        color: Colors.white12,
        child: FutureBuilder<List<TourScheduleList>>(
          future: futurescheduleHistory,
          builder: (context, AsyncSnapshot<List<TourScheduleList>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(child: Text('No tour schedules available.'));
            } else {
              return ListView.separated(
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final scheduleHistory = snapshot.data![index];
                  return Card(
                    elevation: 2,
                    color: Colors.white,
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
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TourScheduleScreen(
                                tourId: scheduleHistory.tourId,
                              ),
                            ),
                          );
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
      location: json['LocationID'] ?? 0,
      tourId: json['TourId'] ?? 0,
    );
  }
}
