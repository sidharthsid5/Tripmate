import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keralatour/Admin_pages/Graph/home_chart.dart';
import 'package:keralatour/Admin_pages/admin_home.dart';
import 'package:keralatour/main.dart';
import 'package:keralatour/User_pages/HomePages/home.dart';
import 'package:keralatour/User_pages/Auth_Pages/login_page.dart';
import 'package:keralatour/User_pages/HomePages/Places/places.dart';
import 'package:keralatour/User_pages/HomePages/Schedule/schedule.dart';
import 'package:keralatour/User_pages/HomePages/Schedule/schedule_history.dart';
import 'package:keralatour/Admin_pages/SocialMedia/live_message.dart';
import 'package:keralatour/Admin_pages/SocialMedia/user_messages.dart';
import 'package:keralatour/Widgets/custom_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String baseUrl = "http://10.11.2.236:4000/";
  bool isUserRegistering = false;
  Future<void> userRegistration(
      {required String email,
      required String password,
      required String name,
      required String lastName,
      required String sex,
      required String age,
      required String country,
      required String currentYear,
      required BuildContext context}) async {
    Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'lastName': lastName,
      'password': password,
      'sex': sex,
      'age': age,
      'country': country,
      'currentYear': currentYear,
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
        if (email == "admin@gmail.com" && password == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ReportsPage(
                userId: userId,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreeenPage(
                userId: userId,
              ),
            ),
          );
        }
      } else {
        CustomAlert.errorMessage("Invalid Username or password", context);
      }
    } catch (e) {
      print('error occurred $e');
    } finally {
      isUserRegistering = false;
      notifyListeners();
    }
  }

  bool iscreateUserSchedule = false;
  Future<void> createUserSchedule({
    required String location,
    required String days,
    required List<String> interests,
    required int userId,
  }) async {
    try {
      iscreateUserSchedule = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(baseUrl + "createSchedule/$userId"),
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
  Future<List<TourSchedule>> getTourSchedules(int tourId) async {
    isUserSchedule = true;
    notifyListeners();

    final response =
        await http.get(Uri.parse(baseUrl + "tourSchedules/$tourId"));
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

  bool isUserScheduleHistory = false;
  Future<List<TourScheduleList>> getTourSchedulesHistory(int userId) async {
    isUserScheduleHistory = true;
    notifyListeners();

    final response =
        await http.get(Uri.parse(baseUrl + "scheduleHistory/$userId"));
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

  bool isLiveMessages = false;
  Future<List<LiveMessages>> getLiveMessages() async {
    isLiveMessages = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "socialMedia"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => LiveMessages.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tour schedules');
    }
  }

  bool isTouristDetails = false;
  Future<List<TouristDetail>> fetchTouristDetails() async {
    isTouristDetails = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "touristdetails"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => TouristDetail.fromJson(e)).toList();
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
  Future<TouristLocation> fetchTouristLocationDetails(int placeId) async {
    final response = await http.get(Uri.parse(baseUrl + "place/$placeId"));

    if (response.statusCode == 200) {
      return TouristLocation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load details');
    }
  }

  Future<TourSchedule> editTourSchedules(int id) async {
    final response = await http.get(Uri.parse(baseUrl + "tourschedules/$id"));
    if (response.statusCode == 200) {
      return TourSchedule.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tour schedule details');
    }
  }

  // ignore: unused_field
  int? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;

  Future<void> fetchUserDetails(int userId) async {
    final response = await http.get(Uri.parse(baseUrl + "user/$userId"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _userId = userId;
      _firstName = data['uname'];
      _lastName = data['ulastName'];
      _email = data['uemail'];
      notifyListeners();
    } else {
      throw Exception('Failed to load user details');
    }
  }

  Future<void> deleteTourSchedule(int scheduleId) async {
    // Your logic to delete the tour schedule from the backend or database
    // For example, making an HTTP request to delete the schedule
    final response = await http.delete(
      Uri.parse(baseUrl + "editSchedules/$scheduleId"),
    );

    if (response.statusCode == 200) {
      // Successfully deleted
      notifyListeners(); // Notify listeners to update UI
    } else {
      throw Exception('Failed to delete the schedule');
    }
  }
}
