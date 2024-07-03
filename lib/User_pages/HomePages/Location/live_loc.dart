import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:keralatour/Widgets/left_navigator.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  final int userId;
  const LocationPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _currentAddress;
  Position? _currentPosition;
  Timer? _locationTimer;
  String? user = "user1";

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

    await Geolocator.isLocationServiceEnabled().then((bool isEnabled) async {
      if (isEnabled) {
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ));
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
      // print('Location sent successfully');
    } else {
      // print('Failed to send location. Status code: ${response.statusCode}');
    }
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _getCurrentPosition();
    });
  }

  void _stopLocationUpdates() {
    if (_locationTimer != null) {
      _locationTimer!.cancel();
      _locationTimer = null;
      // print("stop");
    }
  }

  // void _onTabTapped(int index) {
  //   setState(() {});
  // }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NaviBar(userId: widget.userId),
      appBar: const CustomAppBar(title: 'Tourism'),
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
      // bottomNavigationBar: TourBottomNavigator(
      //   currentIndex: _currentIndex,
      //   onTap: _onTabTapped,
      // ),
    );
  }
}
