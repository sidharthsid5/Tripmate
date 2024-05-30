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
      body: Center(
        child: FutureBuilder<List<TourSchedule>>(
          future: futureTourSchedules,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<Step> steps = [];
              int dayNo = 1; // Initialize day number
              int locationIndex = 0;

              while (locationIndex < snapshot.data!.length) {
                // Add "Day" and "Location" in the title with different colors
                steps.add(
                  Step(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\nDay : $dayNo\n\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: '${snapshot.data![locationIndex].location} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.indigo, // Color for "Location"
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: '\nDistance: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${snapshot.data![locationIndex].distance.toStringAsFixed(2)} km,  ',
                          ),
                          const TextSpan(
                            text: 'Arriving Time: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: '${snapshot.data![locationIndex].time} ',
                          ),
                        ],
                      ),
                    ),
                    content: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "\nCategory: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "${snapshot.data![locationIndex].category},   ",
                          ),
                          const TextSpan(
                            text: "Duration: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "${snapshot.data![locationIndex].duration} Hours",
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= locationIndex,
                  ),
                );

                locationIndex++;

                // Add the next two locations without the "Day" in the title
                for (int i = 0;
                    i < 3 && locationIndex < snapshot.data!.length;
                    i++) {
                  TourSchedule tourSchedule = snapshot.data![locationIndex];
                  steps.add(
                    Step(
                      state: _currentStep > locationIndex
                          ? StepState.complete
                          : StepState.indexed,
                      title: RichText(
                        text: TextSpan(
                          text: '\n${snapshot.data![locationIndex].location}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.indigo, // Color for "Location"
                          ),
                        ),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: '\nDistance: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${tourSchedule.distance.toStringAsFixed(2)} km,  ',
                            ),
                            const TextSpan(
                              text: 'Arriving Time: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: '${snapshot.data![locationIndex].time} \n',
                            ),
                          ],
                        ),
                      ),
                      content: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "Category: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(text: "${tourSchedule.category},  "),
                            const TextSpan(
                              text: "Duration: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(text: "${tourSchedule.duration} Hours"),
                          ],
                        ),
                      ),
                      isActive: _currentStep >= locationIndex,
                    ),
                  );
                  locationIndex++;
                }

                // Increment day number for the next group
                dayNo++;
              }

              return Column(
                children: [
                  Expanded(
                    child: Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme.fromSwatch(
                          primarySwatch:
                              Colors.indigo, // Change primary color here
                        ),
                      ),
                      child: Stepper(
                        type: StepperType.vertical,
                        currentStep: _currentStep,
                        onStepContinue: () {
                          setState(() {
                            if (_currentStep < snapshot.data!.length - 1) {
                              _currentStep++;
                            }
                          });
                        },
                        onStepCancel: () {
                          setState(() {
                            if (_currentStep > 0) {
                              _currentStep--;
                            }
                          });
                        },
                        controlsBuilder:
                            (BuildContext context, ControlsDetails details) {
                          return Row(
                            children: <Widget>[
                              const SizedBox(height: 80.0),
                              ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(color: Colors.green),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 7), // Adjust button padding
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side:
                                          const BorderSide(color: Colors.green),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  int id = snapshot.data![locationIndex].id;

                                  // Call the backend using Provider to delete the location
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .editTourSchedules(id);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 7,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side: const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors
                                        .white, // Example color, change as needed
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: const Text(
                                  'Back',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 7,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side:
                                          const BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors
                                        .white, // Example color, change as needed
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        steps: steps,
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Provider.of<UserProvider>(context, listen: false)
                  //         .deleteTourSchedules();
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const HomeScreeenPage(),
                  //       ),
                  //     );
                  //   },
                  //   child: const Text('Clear'),
                  // ),
                ],
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
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
  final int duration;
  final String location;
  final double distance;
  final String time;
  final String category;
  TourSchedule(
      {required this.id,
      required this.duration,
      required this.location,
      required this.distance,
      required this.time,
      required this.category});

  factory TourSchedule.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return TourSchedule(
      id: json['schedule_id'] ??
          0, // Provide a default value or handle appropriately
      duration: json['time'] ?? 0,
      location: json['location'] ??
          'nothing', // Provide a default value or handle appropriately
      distance: json['distance'] != null
          ? double.parse(json['distance'].toString())
          : 0.0, // Provide a default value or handle appropriately
      time: json['Time'] ?? 0,

      category: json['category'] ?? 'Nil',
    );
  }
}
