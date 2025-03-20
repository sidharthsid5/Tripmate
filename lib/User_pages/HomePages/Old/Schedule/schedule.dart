import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/View_Schedule/schdule_animation.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/View_Schedule/common_schedule.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
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
  String? _selectedLocation; // To store the selected location for replacement

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

  Future<void> _replaceLocation(
      TourSchedule tourSchedule, String newLocation) async {
    // In a real scenario, you would likely want to update this in your data source.
    // For this example, we will just update it locally in the UI.
    setState(() {
      // Find the index of the tourSchedule to be replaced
      int indexToReplace = -1;
      futureTourSchedules.then((schedules) {
        indexToReplace = schedules.indexOf(tourSchedule);
        if (indexToReplace != -1) {
          schedules[indexToReplace] = TourSchedule(
              scheduleId: tourSchedule.scheduleId,
              duration: tourSchedule.duration,
              location: newLocation, // Replace with the new location
              distance: tourSchedule.distance,
              time: tourSchedule.time,
              category: tourSchedule.category,
              imageUrl: tourSchedule.imageUrl,
              district: tourSchedule.district);
        }
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location replaced with: $newLocation')),
    );
  }

  _showReplaceDialog(TourSchedule tourSchedule, List<String> locationNames) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Replace Location'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButtonFormField<String>(
                value: _selectedLocation,
                isExpanded: true, // Prevents overflow of long text
                hint: const Text(
                  'Select New Location',
                  overflow: TextOverflow.ellipsis, // Trims long text
                ),
                items: locationNames.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: FittedBox(
                      // Ensures long text doesn't overflow
                      fit: BoxFit.scaleDown,
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'New Location',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Replace'),
              onPressed: () {
                if (_selectedLocation != null) {
                  _replaceLocation(tourSchedule, _selectedLocation!);
                  Navigator.of(context).pop();
                  _selectedLocation = null;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a new location')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Location-wise Detailed Schedules'),
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
              // Extract location names for dropdown
              List<String> locationNames = snapshot.data!
                  .map((schedule) => schedule.location)
                  .toSet()
                  .toList();

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
                              const SizedBox(height: 70.0),
                              ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text('Confirm',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7),
                                  ),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side:
                                          const BorderSide(color: Colors.green),
                                    ),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
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
                                        horizontal: 10, vertical: 7),
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
                              const SizedBox(width: 7.0),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_currentStep < snapshot.data!.length) {
                                    TourSchedule tourSchedule =
                                        snapshot.data![_currentStep];
                                    _showReplaceDialog(
                                        tourSchedule, locationNames);
                                  }
                                },
                                child: const Text('Replace',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7),
                                  ),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side: const BorderSide(
                                          color: Colors.orangeAccent),
                                    ),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.orange),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TourSchedule2(
                                              userId: widget.userId,
                                              tourId: widget.tourId,
                                            )),
                                  );
                                },
                                child: const Text('Start',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 7),
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
