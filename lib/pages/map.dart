import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
const MapPage({Key? key}) : super(key: key);

@override

_MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MapPage> {

// Here we have created list of steps that
// are required to complete the form

@override
Widget build(BuildContext context) {
	return Scaffold(
	// Here we have initialized the stepper widget 
	body: 
  SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                    Image.asset('assets/images/a.png',width: 1000,height: 670,),
                                   ], ),
                  ),
  ),
	);
}
}
