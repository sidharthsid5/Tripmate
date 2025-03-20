import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:keralatour/Admin_pages/Admin_dashboard/add_newevent.dart';
import 'package:keralatour/Admin_pages/Admin_dashboard/schedule_history.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/behaviour_home.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/demostati_home.dart';
import 'package:keralatour/Admin_pages/dash_tabs/User_clustering/cluster_formation.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Travel_monitoring/movement_track.dart';
import 'package:keralatour/Admin_pages/dash_tabs/SocialMedia/combined_pages.dart';
import 'package:keralatour/Admin_pages/dash_tabs/User_details/user_list.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/Auth_Pages/login_page.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:keralatour/Widgets/side_navigator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardScreen extends StatefulWidget {
  final int userId;
  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NaviBar(userId: widget.userId),
      appBar: CustomAppBar(
        title: (' Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildStatsCards(context, constraints),
                _buildUserDetails(context),
                _buildCalendar(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Events',
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EventPage(),
                            ),
                          );
                        },
                        child: const Text('Add Event'),
                      ),
                    ],
                  ),
                ),
                _buildUpcomingEvents(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome To Your Dashboard',
                  style: GoogleFonts.lato(fontSize: 24)),
              Text('', style: GoogleFonts.lato(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height:
            constraints.maxWidth / 1, // Dynamic height based on screen width
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          mainAxisSpacing: 30.0,
          crossAxisSpacing: 5.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard(
              context,
              'Users Details',
              Icons.supervised_user_circle_sharp,
              const Color.fromARGB(255, 19, 94, 155),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminUserListPage(),
                ),
              ),
            ),
            _buildStatCard(
              context,
              'Demographic statistics',
              Icons.file_copy,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsHomePage(),
                ),
              ),
            ),
            _buildStatCard(
              context,
              'User Analytics Data',
              Icons.assignment,
              const Color.fromARGB(255, 167, 31, 38),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalyticsDashboard(),
                ),
              ),
            ),
            _buildStatCard(
              context,
              'User Clustering',
              Icons.people_alt,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClusterAnimationPage(),
                ),
              ),
            ),
            _buildStatCard(
              context,
              'Travel Monitoring',
              Icons.star,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CoordinatesPage(),
                ),
              ),
            ),
            _buildStatCard(
              context,
              'Social Media',
              Icons.message,
              const Color.fromARGB(255, 0, 109, 45),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportsPage(
                    title: '',
                    content: ' ',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: color),
              const SizedBox(height: 15),
              Text(title,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                  )),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context) {
    int userId = 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule History',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: ScheduleadminHistory(userId: userId),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final eventsMap = _getEventsForCalendar(userProvider.events);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 400,
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          eventLoader: (day) {
            final date = DateTime(day.year, day.month, day.day);
            return eventsMap[date] ?? [];
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleTextStyle: GoogleFonts.lato(fontSize: 16),
            leftChevronIcon: const Icon(Icons.chevron_left),
            rightChevronIcon: const Icon(Icons.chevron_right),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: GoogleFonts.lato(fontSize: 14),
            weekendStyle: GoogleFonts.lato(fontSize: 14),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 2),
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            outsideDaysVisible: false,
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _showEventDetailsForDay(selectedDay);
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return null;
            },
            todayBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Map<DateTime, List<dynamic>> _getEventsForCalendar(List<dynamic> events) {
    Map<DateTime, List<dynamic>> eventsMap = {};

    for (var event in events) {
      DateTime startDate = DateTime.parse(event['start_date']).toLocal();
      DateTime endDate = DateTime.parse(event['end_date']).toLocal();

      startDate = DateTime(startDate.year, startDate.month, startDate.day);
      endDate = DateTime(endDate.year, endDate.month, endDate.day);

      for (DateTime date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
          date = date.add(const Duration(days: 1))) {
        final eventDate = DateTime(date.year, date.month, date.day);

        if (eventsMap[eventDate] == null) {
          eventsMap[eventDate] = [];
        }
        eventsMap[eventDate]!.add(event);
      }
    }

    return eventsMap;
  }

  Widget _buildUpcomingEvents() {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    final events = userProvider.events;

    if (events.isEmpty) {
      return const Center(child: Text('No upcoming events.'));
    }

    return SingleChildScrollView(
      child: Column(
        children: events.map((event) {
          DateTime startDate = DateTime.parse(event['start_date']);
          DateTime endDate = DateTime.parse(event['end_date']);

          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(0, 255, 34, 0.459),
                  Color.fromARGB(255, 0, 150, 136),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  event['event_name'],
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Place: ${event['event_place']}",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Description: ${event['description']}",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Start Date: ${dateFormat.format(startDate)}",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "End Date: ${dateFormat.format(endDate)}",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    bool confirmed = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Event'),
                          content: const Text(
                              'Are you sure you want to delete this event?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true) {
                      try {
                        await userProvider.deleteEvent(event['event_id']);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to delete event: $error')),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showEventDetailsForDay(DateTime selectedDay) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final events = await userProvider.fetchEvents();

    final selectedEvents = events.where((event) {
      final startDate = DateTime.parse(event['start_date']);
      final endDate = DateTime.parse(event['end_date']);

      final normalizedSelectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      final normalizedStartDate =
          DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEndDate =
          DateTime(endDate.year, endDate.month, endDate.day);

      return (normalizedSelectedDay.isAtSameMomentAs(normalizedStartDate) ||
          normalizedSelectedDay.isAtSameMomentAs(normalizedEndDate) ||
          (normalizedSelectedDay.isAfter(normalizedStartDate) &&
              normalizedSelectedDay.isBefore(normalizedEndDate)));
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DateFormat('dd/MM/yyyy').format(selectedDay)),
          content: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    0.5), // 50% of screen height
            child: SingleChildScrollView(
              child: selectedEvents.isEmpty
                  ? const Text('No events for this day.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedEvents.map((event) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 67, 184, 71),
                                  width: 0.0),
                              borderRadius: BorderRadius.circular(8.0),
                              color: const Color.fromARGB(255, 182, 216,
                                  183) // Background color of the container
                              ),
                          child: Text(
                            "${event['event_name']} - ${event['event_place']}\n${event['description']}",
                            style: GoogleFonts.lato(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform logout
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
