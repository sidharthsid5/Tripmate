import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _currentAddress;
  Position? _currentPosition;
  Timer? _locationTimer;
  String? user = "user2";

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    // Force a location update by disabling and enabling location services
    await Geolocator.isLocationServiceEnabled().then((bool isEnabled) async {
      if (isEnabled) {
        // Enable location services
        await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).then((Position position) {
          setState(() => _currentPosition = position);
          _getAddressFromLatLng(_currentPosition!);
          _sendLocationToServer(_currentPosition!, _currentAddress, user);
        }).catchError((e) {
          debugPrint(e);
        });
      } else {
        // Location services are disabled, prompt the user to enable them
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ));
        // You can open the device settings to allow the user to enable location services
        // Alternatively, you can use Geolocator.openAppSettings();
      }
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _sendLocationToServer(
      Position position, String? address, String? user) async {
    //String baseUrl = "http://10.11.2.184:3000/";
    String baseUrl = "http://10.11.2.236:4000/";
    final response = await http.post(
      Uri.parse(baseUrl + "location"),
      body: {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'address': address ?? '',
        'user': user.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Location sent successfully');
    } else {
      print('Failed to send location. Status code: ${response.statusCode}');
    }
  }

  void _startLocationUpdates() {
    // Start the timer to get location updates every 10 seconds
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _getCurrentPosition();
    });
  }

  void _stopLocationUpdates() {
    // Stop the location updates when the "Stop" button is pressed
    if (_locationTimer != null) {
      _locationTimer!.cancel();
      _locationTimer = null;
      print("stop");
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Latitude: ${_currentPosition?.latitude ?? ""}'),
              const SizedBox(height: 15),
              Text('Longitude: ${_currentPosition?.longitude ?? ""}'),
              const SizedBox(height: 15),
              Text('Address: ${_currentAddress ?? ""}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _startLocationUpdates,
                child: const Text("Get Current Location"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _stopLocationUpdates,
                child: const Text("Stop Updation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
