import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:keralatour/Admin_pages/Graph/home_chart.dart';
import 'package:keralatour/Admin_pages/Graph/user_behaviour.dart';
import 'package:keralatour/Admin_pages/SocialMedia/combined_pages.dart';
import 'package:keralatour/Admin_pages/User/recent_user.dart';
import 'package:keralatour/Admin_pages/User/user_list.dart';
import 'package:keralatour/User_pages/Auth_Pages/login_page.dart';
import 'package:keralatour/Widgets/side_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardScreen extends StatefulWidget {
  final int userId;
  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, String>> _events = []; // Initialize as empty

  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  List<Map<String, String?>> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      final eventDate = DateTime.tryParse(event['date'] ?? '');
      return eventDate != null && isSameDay(day, eventDate);
    }).toList();
  }

  void _addEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditEventScreen(
          initialName: '',
          initialTime: '',
          initialLocation: '',
          initialDate: '',
          initialPhoto: '',
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _events.add(result);
      });
    }
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }

  void _showEventDetails(DateTime day) {
    final eventsForDay = _getEventsForDay(day);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Events on ${DateFormat.yMMMd().format(day)}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: eventsForDay.length,
              itemBuilder: (context, index) {
                final event = eventsForDay[index];
                return Card(
                  child: ListTile(
                    leading:
                        event['photo'] != null && event['photo']!.isNotEmpty
                            ? Image.file(
                                File(event['photo']!),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.event),
                    title: Text(event['name'] ?? 'No Name'),
                    subtitle: Text(
                      '${event['time'] ?? 'No Time'} - ${event['location'] ?? 'No Location'}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEventScreen(
                            initialName: event['name'] ?? '',
                            initialTime: event['time'] ?? '',
                            initialLocation: event['location'] ?? '',
                            initialDate: event['date'] ?? '',
                            initialPhoto: event['photo'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NaviBar(userId: widget.userId),
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context); // Show logout confirmation dialog
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
                        onPressed: _addEvent,
                        child: const Text('Add Event'),
                      ),
                    ],
                  ),
                ),
                _buildUpcomingEvents(context),
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
              Text('Hello, Admin', style: GoogleFonts.lato(fontSize: 24)),
              Text('Welcome to your dashboard',
                  style: GoogleFonts.lato(fontSize: 16)),
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
                  builder: (context) => const TouristDetailScreen(),
                ),
              ),
            ),
            _buildStatCard(
              context,
              'User Behaviour Report',
              Icons.assignment,
              const Color.fromARGB(255, 167, 31, 38),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserBehaviour(
                    title: '',
                    content: ' ',
                  ),
                ),
              ),
            ),
            _buildStatCard(
              context,
              'Similar Users',
              Icons.people_alt,
              Colors.red,
              () {
                // Add your navigation logic here
              },
            ),
            _buildStatCard(
              context,
              'Demand Prediction', // New Stat Card 1
              Icons.star,
              Colors.purple,
              () {
                // Add your navigation logic here
              },
            ),
            _buildStatCard(
              context,
              'Social Media', // New Stat Card 2
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Users',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const SizedBox(
            height: 300, // Adjust the height as needed
            child:
                RecentUsersPage(), // Replacing the old _buildRecentCandidates
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 400,
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: (day) => _getEventsForDay(day),
          calendarFormat: CalendarFormat.month,
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
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _showEventDetails(
                selectedDay); // Show event details for the selected day
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._events.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            return _buildEventItem(context, index, event);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEventItem(
      BuildContext context, int index, Map<String, String> event) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event['photo'] != null && event['photo']!.isNotEmpty)
            Image.file(
              File(event['photo']!),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['name']!,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Date: ${event['date']}',
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      Text(
                        'Time: ${event['time']}',
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      Text(
                        'Location: ${event['location']}',
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteEvent(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditEventScreen(
                              initialName: event['name']!,
                              initialTime: event['time']!,
                              initialLocation: event['location']!,
                              initialDate: event['date']!,
                              initialPhoto: event['photo']!,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            _events[index] = result;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform logout
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear shared preferences
                Navigator.of(context).pop(); // Close the dialog
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

class EditEventScreen extends StatefulWidget {
  final String initialName;
  final String initialTime;
  final String initialLocation;
  final String initialDate;
  final String initialPhoto;

  const EditEventScreen({
    super.key,
    required this.initialName,
    required this.initialTime,
    required this.initialLocation,
    required this.initialDate,
    required this.initialPhoto,
  });

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final List<XFile> _photos = [];
  final ImagePicker _picker = ImagePicker();
  String _currentPhoto = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _timeController.text = widget.initialTime;
    _locationController.text = widget.initialLocation;
    _dateController.text = widget.initialDate;
    _currentPhoto = widget.initialPhoto;

    if (_currentPhoto.isNotEmpty) {
      _photos.add(XFile(_currentPhoto));
    }
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _currentPhoto = pickedFile.path;
        _photos.clear();
        _photos.add(pickedFile);
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  void _saveEvent() {
    if (_nameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    Navigator.pop(context, {
      'name': _nameController.text,
      'time': _timeController.text,
      'location': _locationController.text,
      'date': _dateController.text,
      'photo': _currentPhoto,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Event Time'),
                onTap: _selectTime,
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Event Location'),
              ),
              TextField(
                controller: _dateController,
                readOnly: true, // Prevents manual input
                decoration: const InputDecoration(labelText: 'Event Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Change Photo'),
              ),
              const SizedBox(height: 8),
              _photos.isNotEmpty
                  ? Image.file(
                      File(_photos.last.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey[200],
                      child: const Center(child: Text('No Photo')),
                    ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveEvent,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
