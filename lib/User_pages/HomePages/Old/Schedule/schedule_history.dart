import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Old/Schedule/getdata_schedule.dart';
import 'package:keralatour/User_pages/HomePages/Old/Schedule/schedule.dart';
import 'package:keralatour/Widgets/bottom_navigation.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:keralatour/Widgets/floating_action.dart';
import 'package:keralatour/Widgets/side_navigator.dart';
import 'package:keralatour/Widgets/pallete.dart';
import 'package:provider/provider.dart';

class ScheduleHistory extends StatefulWidget {
  final int userId;

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
      backgroundColor: Colors.white10,
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
        color: Colors.white10,
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
                  if (index == 0) {
                    // Highlight the latest schedule
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'New Schedule',
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
                                'Tour ID: 0000000${scheduleHistory.tourId}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'From: ${scheduleHistory.location.toString()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Total Days: ${scheduleHistory.day.toString()}',
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
                                      userId: scheduleHistory.userId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Center(
                          child: Text(
                            'Previous Schedules',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Card(
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
                            'Tour ID: 0000000${scheduleHistory.tourId}',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From: ${scheduleHistory.location.toString()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Total Days: ${scheduleHistory.day.toString()}',
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
                                  userId: scheduleHistory.userId,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
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
