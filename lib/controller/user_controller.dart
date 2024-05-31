import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keralatour/Navigator_bar/navi_bar.dart';
import 'package:keralatour/main.dart';
import 'package:keralatour/pages/Home%20Pages/home.dart';
import 'package:keralatour/pages/Auth%20Pages/login_page.dart';
import 'package:keralatour/pages/Home%20Pages/places.dart';
import 'package:keralatour/pages/Home%20Pages/tourist_places.dart';
import 'package:keralatour/pages/Schedule%20pages/schedule.dart';
import 'package:keralatour/pages/Schedule%20pages/schedule_history.dart';
import 'package:keralatour/pages/user_messages.dart';
import 'package:keralatour/widgets/custom_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String baseUrl = "http://10.11.2.236:4000/";
  bool isUserRegistering = false;
  Future<void> userRegistration(
      {required String email,
      required String password,
      required String name,
      required String lastName,
      required BuildContext context}) async {
    Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'lastName': lastName,
      'password': password
    };
    try {
      isUserRegistering = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(baseUrl + "signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        CustomAlert.successMessage("User created successfully", context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        Map<String, dynamic> result = jsonDecode(response.body);
        CustomAlert.warningMessage(result['message'], context);
      }
    } catch (e) {
      print('error occured $e');
    } finally {
      isUserRegistering = false;
      notifyListeners();
    }
  }

  bool isUserLogining = false;

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    try {
      isUserLogining = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(baseUrl + "signin"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        int userId = responseData['userId'];
        print('User ID retrieved: $userId');
        // GOTO Home
        final _sharedPrefs = await SharedPreferences.getInstance();
        await _sharedPrefs.setBool(SAVE_KEY_NAME, true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreeenPage(),
          ),
        );
      } else {
        CustomAlert.errorMessage("Invalid Username or password", context);
      }
    } catch (e) {
      print('error occured $e');
    } finally {
      isUserRegistering = false;
      notifyListeners();
    }
  }

  late UserDetails _userDetails = UserDetails(userid: 0, email: '', name: '');

  UserDetails get userDetails => _userDetails;

  Future<void> getUserDetails() async {
    final response = await http.get(Uri.parse(baseUrl + "signin"));
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      _userDetails = UserDetails.fromJson(jsonData);
      notifyListeners();
    } else {
      throw Exception('Failed to load user details');
    }
  }

  bool iscreateUserSchedule = false;
  Future<void> createUserSchedule({
    required String location,
    required String days,
    required List<String> interests,
  }) async {
    try {
      iscreateUserSchedule = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(baseUrl + "createSchedule"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'location': location,
          'days': days,
          'interests': interests,
        }),
      );

      if (response.statusCode == 200) {
        // Data sent successfully
        print('Data sent successfully');
      } else {
        // Error in sending data
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      iscreateUserSchedule = false;
      notifyListeners();
    }
  }

  bool isUserSchedule = false;
  Future<List<TourSchedule>> getTourSchedules() async {
    isUserSchedule = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "tourSchedules"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => TourSchedule.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tour schedules');
    }
  }

  bool deleteUserSchedule = false;
  Future<void> deleteTourSchedules() async {
    deleteUserSchedule = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "deleteSchedules"));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load tour schedules');
    }
  }

  bool editUserSchedule = false;
  Future<void> editTourSchedules(id) async {
    editUserSchedule = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "editSchedules"));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete tour schedules');
    }
  }

  bool isUserScheduleHistory = false;
  Future<List<TourScheduleList>> getTourSchedulesHistory() async {
    isUserScheduleHistory = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "scheduleHistory"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => TourScheduleList.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tour schedules');
    }
  }

  bool isSocialMedia = false;
  Future<List<SocialMedia>> getSocialMedia() async {
    isSocialMedia = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "socialMedia"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => SocialMedia.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tour schedules');
    }
  }

  bool isTouristLocation = false;
  Future<List<TouristLocation>> fetchTouristLocation() async {
    isTouristLocation = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "placedetails"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => TouristLocation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tour schedules');
    }
  }

  //  Future<List<GridItem>> fetchGridItems() async {
  //   final response = await http.get(Uri.parse(baseUrl + "placedetails"));
  //   if (response.statusCode == 200) {
  //     List<dynamic> body = json.decode(response.body);
  //     List<GridItem> gridItems = body.map((item) => GridItem.fromJson(item)).toList();
  //     return gridItems;
  //   } else {
  //     throw Exception('Failed to load grid items');
  //   }
  // }
}
