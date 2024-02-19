// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// class LocationPages extends StatefulWidget {
//   const LocationPages({Key? key}) : super(key: key);

//   @override
//   State<LocationPages> createState() => _LocationWidgetState();
// }

// class _LocationWidgetState extends State<LocationPages> {
//   String? _currentAddress;
//   Position? _currentPosition;
//   Timer? _locationTimer;

// Future<bool> _handleLocationPermission() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text(
//             'Location services are disabled. Please enable the services')));
//     return false;
//   }
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permissions are denied')));
//       return false;
//     }
//   }
//   if (permission == LocationPermission.deniedForever) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text(
//             'Location permissions are permanently denied, we cannot request permissions.')));
//     return false;
//   }
//   return true;
// }

// Future<void> _getCurrentPosition() async {
//   final hasPermission = await _handleLocationPermission();

//   if (!hasPermission) return;

//   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//       .then((Position position) {
//     setState(() => _currentPosition = position);
//     _getAddressFromLatLng(_currentPosition!);
//     _sendLocationToServer(_currentPosition!, _currentAddress);
//     _locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
//       _getCurrentPosition();
//     });
//   }).catchError((e) {
//     debugPrint(e);
//   });
// }

// Future<void> _getAddressFromLatLng(Position position) async {
//   await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude)
//       .then((List<Placemark> placemarks) {
//     Placemark place = placemarks[0];
//     setState(() {
//       _currentAddress =
//           '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
//     });
//   }).catchError((e) {
//     debugPrint(e);
//   });
// }

// Future<void> _sendLocationToServer(Position position, String? address) async {
//   String baseUrl = "http://10.11.2.184:3000/";
//   final response = await http.post(
//     Uri.parse(baseUrl + "location"),
//     body: {
//       'latitude': position.latitude.toString(),
//       'longitude': position.longitude.toString(),
//       'address': address ?? '',
//     },
//   );

//   if (response.statusCode == 200) {
//     print('Location sent successfully');
//   } else {
//     print('Failed to send location. Status code: ${response.statusCode}');
//   }
// }

// void _stopLocationUpdates() {
//   // Stop the location updates when the "Stop" button is pressed
//   if (_locationTimer != null) {
//     _locationTimer!.cancel();
//     _locationTimer = null;
//     print("stop");
//   }
// }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Latitude: ${_currentPosition?.latitude ?? ""}'),
//               const SizedBox(height: 15),
//               Text('Longitude: ${_currentPosition?.longitude ?? ""}'),
//               const SizedBox(height: 15),
//               Text('Address: ${_currentAddress ?? ""}'),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: _getCurrentPosition,
//                 child: const Text("Get Current Location"),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _stopLocationUpdates,
//                 child: const Text("Stop"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

     //AndroidManifest.xml

     
//  <manifest xmlns:android="http://schemas.android.com/apk/res/android">
//     <application
//         android:label="keralatour"
//         android:name="${applicationName}"
//         android:icon="@mipmap/ic_launcher">
//         <activity
//             android:name=".MainActivity"
//             android:exported="true"
//             android:launchMode="singleTop"
//             android:theme="@style/LaunchTheme"
//             android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
//             android:hardwareAccelerated="true"
//             android:windowSoftInputMode="adjustResize">
//             <!-- Specifies an Android theme to apply to this Activity as soon as
//                  the Android process has started. This theme is visible to the user
//                  while the Flutter UI initializes. After that, this theme continues
//                  to determine the Window background behind the Flutter UI. -->
//             <meta-data
//               android:name="io.flutter.embedding.android.NormalTheme"
//               android:resource="@style/NormalTheme"
//               />
//             <intent-filter>
//                 <action android:name="android.intent.action.MAIN"/>
//                 <category android:name="android.intent.category.LAUNCHER"/>
//             </intent-filter>
//         </activity>
//         <!-- Don't delete the meta-data below.
//              This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
//         <meta-data
//             android:name="flutterEmbedding"
//             android:value="2" />
//     </application>
// </manifest>