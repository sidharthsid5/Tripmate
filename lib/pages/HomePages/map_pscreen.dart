import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

// Here we have created list of steps that
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/a.png',
              width: 1000,
              height: 670,
            ),
          ],
        ),
      ),
    );
  }
}
