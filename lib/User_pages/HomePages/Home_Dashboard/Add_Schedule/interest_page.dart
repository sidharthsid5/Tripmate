import 'package:flutter/material.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/View_Schedule/schdule_new.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:keralatour/Widgets/pallete.dart';
import 'package:provider/provider.dart';

class PopupContent extends StatefulWidget {
  final int userId;

  const PopupContent({Key? key, required this.userId}) : super(key: key);

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
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
    '10'
  ];
  String? selectedDays;
  bool _isLoading = false;

  void _generateTourPlan() {
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

    setState(() => _isLoading = true);

    Provider.of<UserProvider>(context, listen: false).createUserSchedule(
      location: selectedLocation!,
      days: selectedDays!,
      interests: tags,
      userId: widget.userId,
    );

    Future.delayed(const Duration(seconds: 4), () {
      setState(() => _isLoading = false);
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
                  Icons.arrow_circle_right,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleHistory1(
                        userId: widget.userId,
                      ),
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
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: const CustomAppBar(title: 'Adding Tentative Schedule'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Text(
                  " Current Location : ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() => selectedLocation = newValue);
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedDays,
                  onChanged: (String? newValue) {
                    setState(() => selectedDays = newValue);
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
            const Text(
              " Your Interest:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              choiceStyle: const C2ChoiceStyle(
                color: Pallete.gradient2,
                borderColor: Pallete.gradient2,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              spacing: 10.0,
              runSpacing: 10.0,
              wrapped: true,
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ||
                        selectedLocation == null ||
                        selectedDays == null ||
                        tags.isEmpty
                    ? null
                    : _generateTourPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Generate Tour Plan",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) => setState(() => _selectedIndex = index),
      //   selectedItemColor: Colors.green,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.schedule), label: "Schedules"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.settings), label: "Settings"),
      //   ],
      // ),
    );
  }
}
