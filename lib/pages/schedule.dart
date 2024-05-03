import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:keralatour/pages/home_page.dart';
import 'package:keralatour/pallete.dart';
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
                            text: 'Day : $dayNo\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: snapshot.data![locationIndex].location,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green, // Color for "Location"
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Distance: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                '${snapshot.data![locationIndex].distance.toStringAsFixed(2)} km  ',
                          ),
                          const TextSpan(
                            text: 'Arriving Time: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                            text: "Category: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "${snapshot.data![locationIndex].category}\n",
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
                      title: Text(
                        tourSchedule.location,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Distance: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  '${tourSchedule.distance.toStringAsFixed(2)} km,  ',
                            ),
                            const TextSpan(
                              text: 'Arriving Time: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                              text: "Category: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: "${tourSchedule.category}  "),
                            const TextSpan(
                              text: "Duration: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                    child: Stepper(
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
                      steps: steps,
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
                    },
                    child: const Text('Clear'),
                  ),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FutureBuilder<List<TourSchedule>>(
//           future: futureTourSchedules,
//           builder: (context, snapshot) {
//             if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//               return Column(
//                 children: [
//                   Expanded(
//                     child: Stepper(
//                       currentStep: _currentStep, // Set the current step
//                       onStepContinue: () {
//                         setState(() {
//                           if (_currentStep < snapshot.data!.length - 1) {
//                             _currentStep++; // Move to the next step
//                           }
//                         });
//                       },
//                       onStepCancel: () {
//                         setState(() {
//                           if (_currentStep > 0) {
//                             _currentStep--; // Move to the previous step
//                           }
//                         });
//                       },
//                       steps: snapshot.data!.map<Step>((tourSchedule) {
//                         int index = snapshot.data!.indexOf(tourSchedule);
//                         return Step(
//                           state: _currentStep > index
//                               ? StepState.complete
//                               : StepState.indexed,
//                           title: Text(
//                             tourSchedule.location,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ), // Display the location as the title
//                           subtitle: Text.rich(
//                             TextSpan(
//                               children: [
//                                 const TextSpan(
//                                   text: 'Distance: ',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 TextSpan(
//                                   text:
//                                       '${tourSchedule.distance.toStringAsFixed(2)} km',
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Text(
//                           // 'Distance: ${tourSchedule.distance.toStringAsFixed(2)} km'),
//                           content: Text.rich(
//                             TextSpan(
//                               children: [
//                                 const TextSpan(
//                                   text: "Category: ",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 TextSpan(text: "${tourSchedule.category}\n"),
//                                 const TextSpan(
//                                   text: "Time to explore: ",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 TextSpan(text: "${tourSchedule.time} Hours"),
//                               ],
//                             ),
//                           ),

//                           // Display the distance as the content
//                           isActive: _currentStep >=
//                               index, // Set the step as active based on the current step index
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Provider.of<UserProvider>(context, listen: false)
//                           .deleteTourSchedules();
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const HomeScreeenPage(),
//                         ),
//                       );
//                       // Handle button press here
//                     },
//                     child: const Text('Clear'),
//                   ),
//                 ],
//               );
//             } else if (snapshot.hasData && snapshot.data!.isEmpty) {
//               // If there is no data in snapshot, display a message or any other UI element
//               return const Text('No tour schedules available.');
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             }
//             return const CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }

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
      id: json['id'] ?? 0, // Provide a default value or handle appropriately
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
