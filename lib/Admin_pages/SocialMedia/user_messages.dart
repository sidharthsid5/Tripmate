import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:provider/provider.dart';

class UserMessages extends StatefulWidget {
  const UserMessages({Key? key}) : super(key: key);

  @override
  State<UserMessages> createState() => _ScheduleHistoryState();
}

class _ScheduleHistoryState extends State<UserMessages> {
  late Future<List<SocialMedia>> futurescheduleHistory;

  @override
  void initState() {
    super.initState();
    futurescheduleHistory =
        Provider.of<UserProvider>(context, listen: false).getSocialMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Report'),
      ),
      body: FutureBuilder<List<SocialMedia>>(
        future: futurescheduleHistory,
        builder: (context, AsyncSnapshot<List<SocialMedia>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tour schedules available.'));
          } else {
            List<SocialMedia> filteredList = [];
            for (int i = 0; i < snapshot.data!.length - 1; i++) {
              if (snapshot.data![i].latitude ==
                      snapshot.data![i + 1].latitude &&
                  snapshot.data![i].longitude ==
                      snapshot.data![i + 1].longitude) {
                filteredList.add(snapshot.data![i]);
              }
            }

            if (filteredList.isEmpty) {
              return const Center(child: Text('No matching rows found.'));
            }

            List<SocialMedia> matchedSet1 = filteredList
                .where((socialMedia) => _containsSpecificWords(
                      socialMedia.messages,
                      [
                        'Coast',
                        'Sunset',
                        'Walk',
                        'Waves',
                        'Sand',
                        'Ocean',
                        'Beach'
                      ],
                    ))
                .toList();

            List<SocialMedia> matchedSet2 = filteredList
                .where((socialMedia) => _containsSpecificWords(
                      socialMedia.messages,
                      ['Theater', 'watch', 'Popcorn', 'Film'],
                    ))
                .toList();

            List<SocialMedia> matchedSet3 = filteredList
                .where((socialMedia) => _containsSpecificWords(
                      socialMedia.messages,
                      [
                        'God',
                        'Prayer',
                        'chapel',
                        'church',
                        'worship',
                        'Temple'
                      ],
                    ))
                .toList();

            List<SocialMedia> matchedSet4 = filteredList
                .where((socialMedia) => _containsSpecificWords(
                      socialMedia.messages,
                      ['Room', 'Sleep', 'drinking', 'Booking'],
                    ))
                .toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  child: DataTable(
                    columnSpacing: 16.0,
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueGrey),
                    columns: const [
                      DataColumn(
                          label: Text('User',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Time',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Latitude',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Longitude',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Speed',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Matched heading',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Matching %',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Message',
                              style: TextStyle(color: Colors.white))),
                    ],
                    rows: [
                      ..._buildDataRows(matchedSet1, 'Beach'),
                      ..._buildDataRows(matchedSet2, 'Movie'),
                      ..._buildDataRows(matchedSet3, 'Temple'),
                      ..._buildDataRows(matchedSet4, 'Hotel'),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<DataRow> _buildDataRows(List<SocialMedia> list, String matchedHeading) {
    return list.asMap().entries.map((entry) {
      int index = entry.key;
      SocialMedia socialMedia = entry.value;

      List<String> keywords = [];
      if (matchedHeading == 'Beach') {
        keywords = ['Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach'];
      } else if (matchedHeading == 'Movie') {
        keywords = ['Theater', 'watch', 'Popcorn', 'Film'];
      } else if (matchedHeading == 'Temple') {
        keywords = ['God', 'Prayer', 'chapel', 'church', 'worship', 'Temple'];
      } else if (matchedHeading == 'Hotel') {
        keywords = ['Room', 'Sleep', 'drinking', 'Booking'];
      }

      double matchingPercentage =
          _calculateMatchingPercentage(socialMedia.messages, keywords);

      return DataRow(
        color: MaterialStateColor.resolveWith(
          (states) => index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
        ),
        cells: [
          DataCell(Text(socialMedia.user)),
          DataCell(Text(socialMedia.time)),
          DataCell(Text(socialMedia.latitude)),
          DataCell(Text(socialMedia.longitude)),
          DataCell(Text(socialMedia.speed)),
          DataCell(Text(matchedHeading)),
          DataCell(Text(matchingPercentage.toStringAsFixed(2))),
          DataCell(Container(
            constraints: BoxConstraints(maxWidth: 200),
            child: Text(
              socialMedia.messages,
              overflow: TextOverflow.ellipsis,
            ),
          )),
        ],
      );
    }).toList();
  }

  bool _containsSpecificWords(String message, List<String> words) {
    for (final word in words) {
      if (message.toLowerCase().contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  double _calculateMatchingPercentage(String message, List<String> words) {
    double matchingWords = 0.0;
    for (final word in words) {
      if (message.toLowerCase().contains(word.toLowerCase())) {
        matchingWords++;
      }
    }
    double matchingPercentage = (matchingWords / words.length) * 100;
    return matchingPercentage;
  }
}

class SocialMedia {
  final String latitude;
  final String longitude;
  final String speed;
  final String user;
  final String time;
  final String messages;

  SocialMedia({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.user,
    required this.time,
    required this.messages,
  });

  factory SocialMedia.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return SocialMedia(
      latitude: json['Latitude'] ?? 'nothing',
      longitude: json['Longitude'] ?? 'nothing',
      time: json['Time'] ?? 'Ti',
      user: json['User'] ?? 'Nil',
      speed: json['Speed'] ?? 'speed',
      messages: json['Messages Received'] ?? 'SMS',
    );
  }
}
