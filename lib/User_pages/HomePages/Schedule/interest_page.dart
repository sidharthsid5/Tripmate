import 'package:flutter/material.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Schedule/schedule_history.dart';
import 'package:keralatour/Widgets/pallete.dart';
import 'package:provider/provider.dart';

class PopupContent extends StatefulWidget {
  const PopupContent({Key? key}) : super(key: key);

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent>
    with SingleTickerProviderStateMixin {
  int tag = 1;
  List<String> tags = [];
  List<String> options = [
    'Adventure activities',
    'Beaches',
    'Boating',
    'Church',
    'Hills',
    'Museum',
    'Temple',
    'Waterfalls',
    'Wild Life Sanctuary'
  ];
  List<String> locationOptions = [
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  ];
  String? selectedLocation;
  List<String> daysOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];
  String? selectedDays;

  bool _isLoading = false;

  void _generateTourPlan() {
    // Check if any field is null or empty
    if (selectedLocation == null || selectedDays == null || tags.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Please fill in all fields."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Provider.of<UserProvider>(context, listen: false).createUserSchedule(
      location: selectedLocation!,
      days: selectedDays!,
      interests: tags,
    );

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });

      showSuccessPopup(context);
    });
  }

  void showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Text(
                "Tour Schedule Created Successfully",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
            ],
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          actions: <Widget>[
            Center(
              child: TextButton.icon(
                label: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.green, // Change icon color here
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScheduleHistory(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      // Adjust the background color and opacity
      body: Center(
        child: Container(
          width: screenSize.width * 0.9, // Set 80% of the screen width
          height: screenSize.height * 0.7,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Text(
                    " Current Location : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedLocation,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLocation = newValue;
                      });
                    },
                    items: locationOptions.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Pallete.green),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    " No. of Days          : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedDays,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDays = newValue;
                      });
                    },
                    items: daysOptions.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Pallete.green),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              const Row(
                children: [
                  Text(
                    " Your  Interest      :",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ChipsChoice<String>.multiple(
                value: tags,
                onChanged: (val) => setState(() => tags = val),
                choiceItems: C2Choice.listFrom(
                  source: options,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                choiceActiveStyle: const C2ChoiceStyle(
                  color: Pallete.green,
                  borderColor: Pallete.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                choiceStyle: const C2ChoiceStyle(
                  color: Pallete.gradient2,
                  borderColor: Pallete.gradient2,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                spacing: 10.0,
                runSpacing: 10.0,
                wrapped: true,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 30),
              AnimatedPadding(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.00),
                  child: ElevatedButton(
                    onPressed: _isLoading ||
                            selectedLocation == null ||
                            selectedDays == null ||
                            tags.isEmpty
                        ? null
                        : _generateTourPlan,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.green),
                      shadowColor: WidgetStateProperty.all<Color>(Colors.green),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _isLoading ? Colors.green : Colors.green,
                            _isLoading ? Colors.lightGreen : Colors.lightGreen,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: _isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              ),
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Generate Tour Plan",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
