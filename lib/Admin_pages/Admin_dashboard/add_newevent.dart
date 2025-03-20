import 'package:provider/provider.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/pallete.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _eventFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _eventPlaceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  bool pwVisible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isDarkMode
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5), blurRadius: 10)
                  ]
                : [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3), blurRadius: 10)
                  ],
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.30,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      image: DecorationImage(
                        image: NetworkImage(
                            '/home/hp/Tour/keralatour/assets/images/wayanad.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.00),
                    child: Form(
                      key: _eventFormKey,
                      child: Column(
                        children: [
                          buildTextField(
                            "Event Name",
                            Icons.event_available,
                            false,
                            size,
                            (value) {
                              if (value!.length <= 2) {
                                buildSnackError(
                                  'Invalid Name',
                                  context,
                                  size,
                                );
                                return '';
                              }
                              if (!RegExp(r"^[a-zA-Z]").hasMatch(value)) {
                                buildSnackError(
                                  'Invalid Name',
                                  context,
                                  size,
                                );
                                return '';
                              }
                              return null;
                            },
                            _nameController,
                            isDarkMode,
                          ),
                          buildTextField(
                            "Event Place",
                            Icons.location_on_outlined,
                            false,
                            size,
                            (value) {
                              if (value!.isEmpty) {
                                buildSnackError(
                                  'Event place is required',
                                  context,
                                  size,
                                );
                                return '';
                              }
                              return null;
                            },
                            _eventPlaceController,
                            isDarkMode,
                          ),
                          buildTextField(
                            "Description",
                            Icons.description_outlined,
                            false,
                            size,
                            (value) {
                              if (value!.isEmpty) {
                                buildSnackError(
                                  'Description is required',
                                  context,
                                  size,
                                );
                                return '';
                              }
                              return null;
                            },
                            _descriptionController,
                            isDarkMode,
                          ),
                          buildDateField(
                            "Start Date",
                            size,
                            _startDateController,
                            (pickedDate) {
                              setState(() {
                                _startDate = pickedDate;
                                _endDateController
                                    .clear(); // Clear end date if start date is changed
                              });
                            },
                            isDarkMode,
                          ),
                          buildDateField(
                            "End Date",
                            size,
                            _endDateController,
                            (pickedDate) {
                              setState(() {
                                _endDate = pickedDate;
                              });
                            },
                            isDarkMode,
                            firstDate: _startDate,
                          ),
                          AnimatedPadding(
                            duration: const Duration(milliseconds: 500),
                            padding: EdgeInsets.only(top: size.height * 0.015),
                            child: ButtonWidget(
                              text: "Add Event",
                              backColor: isDarkMode
                                  ? [Colors.black, Colors.black]
                                  : [Pallete.green, Colors.teal],
                              textColor: const [Colors.white, Colors.white],
                              onPressed: () async {
                                if (_eventFormKey.currentState!.validate()) {
                                  if (_startDate == null || _endDate == null) {
                                    buildSnackError(
                                      'Start and End dates are required',
                                      context,
                                      size,
                                    );
                                    return;
                                  }

                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .adminAddEvent(
                                    name: _nameController.text,
                                    eventPlace: _eventPlaceController.text,
                                    description: _descriptionController.text,
                                    startDate: _startDate!,
                                    endDate: _endDate!,
                                    context: context,
                                  );

                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String hintText,
    IconData icon,
    bool password,
    Size size,
    FormFieldValidator<String> validator,
    TextEditingController controller,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.09,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
                color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: password ? !pwVisible : false,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(color: Color(0xffADA4A5)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Pallete.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Pallete.borderColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Pallete.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.only(
                  left: size.width * 0.1, top: size.height * 0.012),
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: size.width * 0.02),
                child: Icon(icon, color: const Color(0xff7B6F72)),
              ),
              suffixIcon: password
                  ? Padding(
                      padding: EdgeInsets.only(left: size.width * 0.02),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pwVisible = !pwVisible;
                          });
                        },
                        child: pwVisible
                            ? const Icon(Icons.visibility_off_outlined,
                                color: Color.fromARGB(255, 80, 72, 72))
                            : const Icon(Icons.visibility_outlined,
                                color: Color.fromARGB(255, 80, 72, 72)),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDateField(
    String hintText,
    Size size,
    TextEditingController controller,
    void Function(DateTime pickedDate) onDateSelected,
    bool isDarkMode, {
    DateTime? firstDate,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.09,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
                color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
            readOnly: true,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: firstDate ?? DateTime.now(),
                firstDate: firstDate ?? DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (selectedDate != null) {
                setState(() {
                  controller.text = "${selectedDate.toLocal()}".split(' ')[0];
                  onDateSelected(selectedDate);
                });
              }
            },
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(color: Color(0xffADA4A5)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Pallete.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Pallete.borderColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Pallete.green, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.only(
                  left: size.width * 0.1, top: size.height * 0.012),
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: size.width * 0.02),
                child: const Icon(Icons.date_range, color: Color(0xff7B6F72)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void buildSnackError(String text, BuildContext context, Size size) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(fontSize: size.height * 0.022)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
