import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:provider/provider.dart';

class ScheduleHistory extends StatefulWidget {
  const ScheduleHistory({Key? key}) : super(key: key);

  @override
  State<ScheduleHistory> createState() => _ScheduleHistoryState();
}

class _ScheduleHistoryState extends State<ScheduleHistory> {
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
        title: const Text('Schedule History'),
      ),
      body: FutureBuilder<List<SocialMedia>>(
        future: futurescheduleHistory,
        builder: (context, AsyncSnapshot<List<SocialMedia>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is being fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error fetching data, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there is no data available, display a message
            return Center(child: Text('No tour schedules available.'));
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
              return Center(child: Text('No matching rows found.'));
            }

            // Filter messages with specific keywords in four sets
            List<SocialMedia> matchedSet1 = filteredList
                .where((socialMedia) => _containsSpecificWords(
                      socialMedia.messages,
                      ['car', 'school', 'stay', 'death'],
                    ))
                .toList();

            List<SocialMedia> matchedSet2 = filteredList
                .where((socialMedia) => _containsSpecificWords(
                      socialMedia.messages,
                      ['nope', 'ear', 'cake'],
                    ))
                .toList();

            List<SocialMedia> matchedSet3 = filteredList
                .where((socialMedia) => _containsSpecificWords(
                      socialMedia.messages,
                      ['work', 'travel', 'vacation'],
                    ))
                .toList();

            List<SocialMedia> matchedSet4 = filteredList
                .where((socialMedia) => _containsSpecificWords(
                      socialMedia.messages,
                      ['goodbye', 'funeral', 'condolences'],
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
                  DataColumn(label: Text('Message')),
                  DataColumn(label: Text('Matched heading')),
                  DataColumn(label: Text('Matching %')),
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
      double matchingPercentage = _calculateMatchingPercentage(
          socialMedia.messages,
          matchedHeading == 'Beach'
              ? ['Coast', 'Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach']
              : matchedHeading == 'Movie'
                  ? ['Theater', 'watch', 'Popcorn', 'Film']
                  : matchedHeading == 'Temple'
                      ? [
                          'God',
                          'Prayer',
                          'chapel',
                          'church',
                          'worship',
                          'Temple'
                        ]
                      : ['Room', 'Sleep', 'Lounge', 'Booking']);

      return DataRow(cells: [
        DataCell(Text(socialMedia.user)),
        DataCell(Text(socialMedia.latitude)),
        DataCell(Text(socialMedia.longitude)),
        DataCell(Text(socialMedia.speed)),
        DataCell(Text(socialMedia.time)),
        DataCell(Text(socialMedia.messages)),
        DataCell(Text(matchedHeading)),
        DataCell(Text(matchingPercentage.toStringAsFixed(2))),
      ]);
    }).toList();
  }

  bool _containsSpecificWords(String message, List<String> words) {
    for (final word in words) {
      if (message.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }

  double _calculateMatchingPercentage(String message, List<String> words) {
    double totalWords = message.split(' ').length.toDouble();
    double matchingWords = 0.0;

    for (final word in words) {
      if (message.toLowerCase().contains(word)) {
        matchingWords++;
      }
    }

    return (matchingWords / totalWords) * 100;
  }
}

class SocialMedia {
  //final int id;
  final String latitude;
  final String longitude;
  final String speed;
  final String user;
  final String time;
  final String messages;
  SocialMedia(
      {required this.messages,
      required this.latitude,
      required this.longitude,
      required this.speed,
      required this.user,
      required this.time});

  factory SocialMedia.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return SocialMedia(
      //id: json['loc_id'] ??
      //   0, // Provide a default value or handle appropriately
      latitude: json['Latitude'] ??
          'nothing', // Provide a default value or handle appropriately
      longitude: json['Longitude'] ??
          'nothing', // Provide a default value or handle appropriately
      time: json['Time'] ?? 'Ti',
      user: json['User'] ?? 'Nil',
      speed: json['Speed'] ?? 'speed',

      messages: json['Messages Received'] ?? 'SMS',
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:keralatour/controller/user_controller.dart';
// import 'package:provider/provider.dart';

// class ScheduleHistory extends StatefulWidget {
//   const ScheduleHistory({Key? key}) : super(key: key);

//   @override
//   State<ScheduleHistory> createState() => _ScheduleHistoryState();
// }

// class _ScheduleHistoryState extends State<ScheduleHistory> {
//   late Future<List<SocialMedia>> futurescheduleHistory;

//   @override
//   void initState() {
//     super.initState();
//     futurescheduleHistory =
//         Provider.of<UserProvider>(context, listen: false).getSocialMedia();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Schedule History Report'),
//       ),
//       body: FutureBuilder<List<SocialMedia>>(
//         future: futurescheduleHistory,
//         builder: (context, AsyncSnapshot<List<SocialMedia>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No tour schedules available.'));
//           } else {
//             // Filter rows based on messages containing specific words
//             final List<String> wordsToMatch1 = ["car", "school", "stay", "death"];
//             final List<String> wordsToMatch2 = ["nope", "ear", "cake"];

//             final List<SocialMedia> matchedList1 = [];
//             final List<SocialMedia> matchedList2 = [];

//             for (int i = 0; i < snapshot.data!.length; i++) {
//               final SocialMedia scheduleHistory = snapshot.data![i];
//               final String messages = scheduleHistory.messages.toLowerCase();

//               // Check if messages contain any of the words in wordsToMatch1
//               if (wordsToMatch1.any((word) => messages.contains(word))) {
//                 matchedList1.add(scheduleHistory);
//               }

//               // Check if messages contain any of the words in wordsToMatch2
//               if (wordsToMatch2.any((word) => messages.contains(word))) {
//                 matchedList2.add(scheduleHistory);
//               }
//             }

//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: const [
//                   DataColumn(label: Text('Matched')),
//                   DataColumn(label: Text('User')),
//                   DataColumn(label: Text('Latitude')),
//                   DataColumn(label: Text('Longitude')),
//                   DataColumn(label: Text('Speed')),
//                   DataColumn(label: Text('Time')),
//                   DataColumn(label: Text('Message')),
//                 ],
//                 rows: [
//                   ...matchedList1.map((scheduleHistory) => DataRow(
//                         cells: [
//                           DataCell(Text('Matched 1')),
//                           DataCell(Text(scheduleHistory.user)),
//                           DataCell(Text(scheduleHistory.latitude)),
//                           DataCell(Text(scheduleHistory.longitude)),
//                           DataCell(Text(scheduleHistory.speed)),
//                           DataCell(Text(scheduleHistory.time)),
//                           DataCell(Text(scheduleHistory.messages)),
//                         ],
//                       )),
//                   ...matchedList2.map((scheduleHistory) => DataRow(
//                         cells: [
//                           DataCell(Text('Matched 2')),
//                           DataCell(Text(scheduleHistory.user)),
//                           DataCell(Text(scheduleHistory.latitude)),
//                           DataCell(Text(scheduleHistory.longitude)),
//                           DataCell(Text(scheduleHistory.speed)),
//                           DataCell(Text(scheduleHistory.time)),
//                           DataCell(Text(scheduleHistory.messages)),
//                         ],
//                       )),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
