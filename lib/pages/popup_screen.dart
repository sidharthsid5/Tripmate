import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:keralatour/pages/home.dart';
import 'package:keralatour/pages/status.dart';
import 'package:keralatour/pallete.dart';
import 'package:keralatour/widgets/button_widget.dart';

class PopupContent extends StatefulWidget {
  const PopupContent({super.key});

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
    'Mountain',
    'Museum',
    'Temples',
    'Waterfall',
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
                  // disabled: (i, v) => [0, 2, 5].contains(i),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.80),
                child: ButtonWidget(
                  text: "Generate Tour Plan",
                  backColor: const [Pallete.green, Pallete.green],
                  textColor: const [
                    Colors.white,
                    Colors.white,
                  ],
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
