import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
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
            // While data is being fetched, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error fetching data, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there is no data available, display a message
            return const Center(child: Text('No tour schedules available.'));
          } else {
            // Find rows with similar latitude and longitude
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
              // If no matching rows are found, display a message
              return const Center(child: Text('No matching rows found.'));
            }

            // Filter messages with specific keywords in four sets
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

            // Display the report in a table
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Latitude')),
                  DataColumn(label: Text('Longitude')),
                  DataColumn(label: Text('Speed')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Matched heading')),
                  DataColumn(label: Text('Matching %')),
                  DataColumn(label: Text('Message')),
                ],
                rows: [
                  ..._buildDataRows(matchedSet1, 'Beach'),
                  ..._buildDataRows(matchedSet2, 'Movie'),
                  ..._buildDataRows(matchedSet3, 'Temple'),
                  ..._buildDataRows(matchedSet4, 'Hotel'),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<DataRow> _buildDataRows(List<SocialMedia> list, String matchedHeading) {
    return list.map((socialMedia) {
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

      return DataRow(cells: [
        DataCell(Text(socialMedia.user)),
        DataCell(Text(socialMedia.latitude)),
        DataCell(Text(socialMedia.longitude)),
        DataCell(Text(socialMedia.speed)),
        DataCell(Text(socialMedia.time)),
        DataCell(Text(matchedHeading)),
        DataCell(Text(matchingPercentage.toStringAsFixed(2))),
        DataCell(Text(socialMedia.messages)),
      ]);
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
    // Calculate the total number of words in the message
    // double totalWords = message.split(' ').length.toDouble();
    // Initialize a counter for matching words
    double matchingWords = 0.0;

    // Iterate over each word in the provided list
    for (final word in words) {
      // Check if the lowercase version of the message contains the lowercase version of the word
      if (message.toLowerCase().contains(word.toLowerCase())) {
        // If a match is found, increment the matchingWords counter
        matchingWords++;
      }
    }

    // Calculate the percentage of matching words
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
