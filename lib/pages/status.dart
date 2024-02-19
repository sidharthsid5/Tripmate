import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StatusPage> {
// Here we have created list of steps that
// are required to complete the form
  List<Step> stepList() => [
        const Step(
            title: Text('Kochi'),
            content: Center(
              child: Text('9.00 AM'),
            )),
        const Step(
            title: Text('Munnar'),
            content: Center(
              child: Text('1.00 PM'),
            )),
        const Step(
            title: Text('Vagamon'),
            content: Center(
              child: Text('9.00 PM'),
            )),
        const Step(
            title: Text('Kottayam'),
            content: Center(
              child: Text('10.00 PM'),
            )),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Here we have initialized the stepper widget
        body: Stepper(
      steps: stepList(),
    ));
  }
}
