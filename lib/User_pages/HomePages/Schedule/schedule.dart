import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/HomePages/Location/live_loc.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/Controller/user_controller.dart';

class TourScheduleScreen extends StatefulWidget {
  final int tourId;
  final int userId;
  const TourScheduleScreen(
      {Key? key, required this.tourId, required this.userId})
      : super(key: key);

  @override
  _TourScheduleScreenState createState() => _TourScheduleScreenState();
}

class _TourScheduleScreenState extends State<TourScheduleScreen> {
  late Future<List<TourSchedule>> futureTourSchedules;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    futureTourSchedules = Provider.of<UserProvider>(context, listen: false)
        .getTourSchedules(widget.tourId);
  }

  Future<void> _deleteSchedule(int scheduleId) async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .deleteTourSchedule(scheduleId);
      setState(() {
        futureTourSchedules = Provider.of<UserProvider>(context, listen: false)
            .getTourSchedules(widget.tourId);
        // Adjust current step if it exceeds the new number of steps
        futureTourSchedules.then((schedules) {
          if (_currentStep >= schedules.length) {
            _currentStep = schedules.length - 1;
          }
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<List<TourSchedule>>(
          future: futureTourSchedules,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No tour schedules available.');
            } else {
              List<Step> steps = [];
              int dayNo = 1;
              int locationIndex = 0;

              while (locationIndex < snapshot.data!.length) {
                steps.add(
                  Step(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\nDay : $dayNo\n\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: snapshot.data![locationIndex].location,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.green,
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
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          TextSpan(
                            text:
                                '${snapshot.data![locationIndex].distance.toStringAsFixed(2)} km,  ',
                          ),
                          const TextSpan(
                            text: 'Arriving Time: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
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
                          text: '\n${tourSchedule.location}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: '\nDistance: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            TextSpan(
                              text:
                                  '${tourSchedule.distance.toStringAsFixed(2)} km,  ',
                            ),
                            const TextSpan(
                              text: 'Arriving Time: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            TextSpan(
                              text: '${tourSchedule.time} \n',
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
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            TextSpan(text: "${tourSchedule.category},  "),
                            const TextSpan(
                              text: "Duration: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
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

                dayNo++;
              }

              return Column(
                children: [
                  Expanded(
                    child: Theme(
                      data: ThemeData(
                        colorScheme:
                            ColorScheme.fromSwatch(primarySwatch: Colors.green),
                      ),
                      child: Stepper(
                        type: StepperType.vertical,
                        currentStep: _currentStep,
                        onStepTapped: (int step) {
                          setState(() {
                            _currentStep = step;
                          });
                        },
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
                                child: const Text('Confirm',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
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
                                          Colors.green),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_currentStep < snapshot.data!.length) {
                                    await _deleteSchedule(snapshot
                                        .data![_currentStep].scheduleId);
                                  }
                                },
                                child: const Text('Remove',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                  ),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side: const BorderSide(
                                          color: Colors.redAccent),
                                    ),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.red),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationPage(
                                              userId: widget.userId,
                                            )),
                                  );
                                },
                                child: const Text('Start',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                  ),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                              ),
                            ],
                          );
                        },
                        steps: steps,
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

class TourSchedule {
  final int scheduleId;
  final int duration;
  final String location;
  final double distance;
  final String time;
  final String category;

  TourSchedule({
    required this.scheduleId,
    required this.duration,
    required this.location,
    required this.distance,
    required this.time,
    required this.category,
  });

  factory TourSchedule.fromJson(Map<String, dynamic> json) {
    return TourSchedule(
      scheduleId: json['schedule_id'] ?? 0,
      duration: json['time'] ?? 0,
      location: json['location'] ?? 'nothing',
      distance: json['distance'] != null
          ? double.parse(json['distance'].toString())
          : 0.0,
      time: json['Time'] ?? 'N/A',
      category: json['category'] ?? 'Nil',
    );
  }
}
