import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:keralatour/pages/home_page.dart';
import 'package:provider/provider.dart';

class TourScheduleScreen extends StatefulWidget {
  const TourScheduleScreen({super.key});

  @override
  _TourScheduleScreenState createState() => _TourScheduleScreenState();
}

class _TourScheduleScreenState extends State<TourScheduleScreen> {
  late Future<List<TourSchedule>> futureTourSchedules;

  @override
  void initState() {
    super.initState();
    futureTourSchedules =
        Provider.of<UserProvider>(context, listen: false).getTourSchedules();
  }

  int _currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<TourSchedule>>(
          future: futureTourSchedules,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: Stepper(
                      currentStep: _currentStep, // Set the current step
                      onStepContinue: () {
                        setState(() {
                          if (_currentStep < snapshot.data!.length - 1) {
                            _currentStep++; // Move to the next step
                          }
                        });
                      },
                      onStepCancel: () {
                        setState(() {
                          if (_currentStep > 0) {
                            _currentStep--; // Move to the previous step
                          }
                        });
                      },
                      steps: snapshot.data!.map<Step>((tourSchedule) {
                        int index = snapshot.data!.indexOf(tourSchedule);
                        return Step(
                          state: _currentStep > index
                              ? StepState.complete
                              : StepState.indexed,
                          title: Text(
                            tourSchedule.location,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ), // Display the location as the title
                          subtitle: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Distance: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      '${tourSchedule.distance.toStringAsFixed(2)} km',
                                ),
                              ],
                            ),
                          ),

                          // Text(
                          // 'Distance: ${tourSchedule.distance.toStringAsFixed(2)} km'),
                          content: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Category: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "${tourSchedule.category}\n"),
                                const TextSpan(
                                  text: "Time to explore: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "${tourSchedule.time} Hours"),
                              ],
                            ),
                          ),

                          // Display the distance as the content
                          isActive: _currentStep >=
                              index, // Set the step as active based on the current step index
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .deleteTourSchedules();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreeenPage(),
                        ),
                      );
                      // Handle button press here
                    },
                    child: const Text('Clear'),
                  ),
                ],
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              // If there is no data in snapshot, display a message or any other UI element
              return const Text('No tour schedules available.');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class TourSchedule {
  final int id;
  final String location;
  final double distance;
  final int time;
  final String category;
  TourSchedule(
      {required this.id,
      required this.location,
      required this.distance,
      required this.time,
      required this.category});

  factory TourSchedule.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return TourSchedule(
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
