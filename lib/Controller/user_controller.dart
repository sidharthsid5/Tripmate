import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keralatour/Admin_pages/Admin_dashboard/schedule_history.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/coordinates_table.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/places_tablepage.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/tourism_datapage.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Behaviour_report/Behave_tabs/user_clustering.dart';
import 'package:keralatour/Admin_pages/dash_tabs/Demo_statistics/Filtered_Reports/Overall_trends/home_chart.dart';
import 'package:keralatour/Admin_pages/Admin_dashboard/admin_dash.dart';
import 'package:keralatour/Admin_pages/dash_tabs/SocialMedia/class_social.dart';
import 'package:keralatour/Admin_pages/dash_tabs/User_details/user_list.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/new_dashboard.dart';
import 'package:keralatour/User_pages/HomePages/Old/Schedule/getdata_schedule.dart';
import 'package:keralatour/main.dart';
import 'package:keralatour/User_pages/Auth_Pages/login_page.dart';
import 'package:keralatour/User_pages/HomePages/Old/Places/places.dart';
import 'package:keralatour/Admin_pages/dash_tabs/SocialMedia/live_message.dart';
import 'package:keralatour/Widgets/custom_alerts.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/View_Schedule/common_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String baseUrl = "http://10.11.3.126:4000/";
  bool isUserRegistering = false;
  bool isUserLogining = false;

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

  bool isAddEvent = false;

  Future<void> adminAddEvent({
    required String name,
    required String eventPlace,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required BuildContext context,
  }) async {
    Map<String, dynamic> data = {
      'name': name,
      'eventPlace': eventPlace,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };

    try {
      isAddEvent = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(baseUrl + "addevent"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        CustomAlert.successMessage("Event added successfully", context);
        await fetchEvents(); // Refresh the event list
      } else {
        final result = jsonDecode(response.body);
        CustomAlert.warningMessage(
            result['message'] ?? 'An error occurred', context);
      }
    } catch (e) {
      CustomAlert.errorMessage("An unexpected error occurred: $e", context);
    } finally {
      isAddEvent = false;
      notifyListeners();
    }
  }

  List<dynamic> _events = [];

  List<dynamic> get events => _events;

  Future<List<dynamic>> fetchEvents() async {
    final response = await http.get(Uri.parse(baseUrl + "events"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      _events = responseData['data'] ?? []; // Update the internal state
      notifyListeners(); // Notify listeners of the change
      return _events;
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl + "events/$eventId"),
      );

      if (response.statusCode == 200) {
        _events.removeWhere(
            (event) => event['event_id'] == eventId); // Update the list
        notifyListeners(); // Notify listeners to rebuild UI
      } else {
        throw Exception('Failed to delete event');
      }
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
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

        // Fetch user details after successful login
        await fetchUserDetails(userId);

        // Save login state
        final _sharedPrefs = await SharedPreferences.getInstance();
        await _sharedPrefs.setBool(SAVE_KEY_NAME, true);

        // Navigate to the correct page
        if (email == "admin@gmail.com" && password == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(userId: userId),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TravelAppHomePage(userId: userId),
            ),
          );
        }
      } else {
        CustomAlert.errorMessage("Invalid Username or password", context);
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      isUserLogining = false;
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

  bool isAdminScheduleHistory = false;
  Future<List<AdminTourScheduleList>> getAdminTourSchedulesHistory() async {
    isUserScheduleHistory = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "scheduleHistoryss"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => AdminTourScheduleList.fromJson(e)).toList();
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

  Future<List<TouristLocation>> fetchPopularDestinations() async {
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

  bool isFetchingCoordinatesTable = false;
  List<CoordinatesData> coordinatesTable = [];

  Future<void> fetchCoordinatesTable() async {
    isFetchingCoordinatesTable = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(baseUrl + "coordinates1"));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        coordinatesTable =
            jsonList.map((e) => CoordinatesData.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load coordinates');
      }
    } catch (e) {
      print("Error fetching coordinates table: $e");
    } finally {
      isFetchingCoordinatesTable = false;
      notifyListeners();
    }
  }

  Future<List<PlacesData>> fetchPlacesTable() async {
    final response = await http.get(Uri.parse(baseUrl + "placesTable"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => PlacesData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load places data');
    }
  }

  Future<List<TourismData>> fetchTourismData() async {
    final response = await http.get(Uri.parse(baseUrl + "tourismData1"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => TourismData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tourism data');
    }
  }

  bool isFetchingCoordinatesTable2 = false;

  List<CoordinatesData5> coordinatesTable2 = [];

  Future<void> fetchCoordinatesTable2() async {
    isFetchingCoordinatesTable2 = true;

    notifyListeners();

    print("Fetching from: ${baseUrl}coordinates2");

    try {
      final response = await http.get(Uri.parse(baseUrl + "coordinates2"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        coordinatesTable2 =
            jsonList.map((e) => CoordinatesData5.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load coordinates');
      }
    } catch (e) {
      print("Error fetching coordinates table: $e");
    } finally {
      isFetchingCoordinatesTable2 = false;

      notifyListeners();
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
    final response = await http.delete(
      Uri.parse(baseUrl + "editSchedules/$scheduleId"),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed to delete the schedule');
    }
  }

  bool isfetchUsers = false;
  Future<List<UserList>> fetchUsers() async {
    isfetchUsers = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl + "UserList"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => UserList.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Users list');
    }
  }
}
