import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
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
      appBar: AppBar(
        title: const Text('Tour Schedules'),
      ),
      body: Center(
        child: FutureBuilder<List<TourSchedule>>(
          future: futureTourSchedules,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stepper(
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
                    title: Text(tourSchedule
                        .location), // Display the location as the title
                    content: Text(
                        '${tourSchedule.distance.toStringAsFixed(2)} km'), // Display the distance as the content
                    isActive: _currentStep ==
                        index, // Set the step as active based on the current step index
                  );
                }).toList(),
              );
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

  TourSchedule(
      {required this.id, required this.location, required this.distance});

  factory TourSchedule.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return TourSchedule(
      id: json['id'] ?? 0, // Provide a default value or handle appropriately
      location: json['Tourlocation'] ??
          'nothing', // Provide a default value or handle appropriately
      distance: json['distance'] != null
          ? double.parse(json['distance'].toString())
          : 0.0, // Provide a default value or handle appropriately
    );
  }
}
