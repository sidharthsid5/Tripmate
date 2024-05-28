// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';

// class CsvProcessingScreen extends StatefulWidget {
//   const CsvProcessingScreen({super.key});

//   @override
//   _CsvProcessingScreenState createState() => _CsvProcessingScreenState();
// }

// class _CsvProcessingScreenState extends State<CsvProcessingScreen> {
//   List<List<dynamic>> _data = [];
//   List<Map<String, dynamic>> _processedData = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadCsvFile();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('CSV Processing'),
//       ),
//       body: _data.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _processedData.length,
//               itemBuilder: (context, index) {
//                 final row = _processedData[index];
//                 return ListTile(
//                   title: Text(
//                       'User ID: ${row["User ID"]}, Latitude: ${row["Latitude"]}, Longitude: ${row["Longitude"]}'),
//                   subtitle: Text(
//                       'Matched Heading: ${row["Matched Heading"]}, Stay Duration: ${row["Stay Duration (minutes)"]} mins'),
//                 );
//               },
//             ),
//     );
//   }

//   Future<void> _loadCsvFile() async {
//     final csvData = await rootBundle.loadString('assets/Final.csv');
//     List<List<dynamic>> fields = const CsvToListConverter().convert(csvData);

//     setState(() {
//       _data = fields;
//       _processedData = _processData(fields);
//     });
//   }

//   List<Map<String, dynamic>> _processData(List<List<dynamic>> data) {
//     final predefinedWords = {
//       "Beach": ['Coast', 'Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach'],
//       "Hotel": ['Room', 'Sleep', 'Lounge', 'Booking'],
//       "Movie": ['Theater', 'watch', 'Popcorn', 'Film'],
//       "Temple": ['God', 'Prayer', 'chapel', 'church', 'worship', 'Temple'],
//     };

//     List<Map<String, dynamic>> result = [];
//     for (var row in data.skip(1)) {
//       var message = row[4];
//       var matchedHeadings = _wordMatch(message.toString(), predefinedWords);

//       if (matchedHeadings.isNotEmpty) {
//         var stayDuration = _calculateStayDuration(row, data);
//         if (stayDuration > 10) {
//           result.add({
//             "User ID": row[0],
//             "Latitude": row[2],
//             "Longitude": row[3],
//             "Timestamp": row[5],
//             "Stay Duration (minutes)": stayDuration,
//             "Matched Heading": matchedHeadings.keys.join(', '),
//             "Percentage Matched": matchedHeadings.values.join(', '),
//             "Message": message,
//           });
//         }
//       }
//     }
//     return result;
//   }

//   Map<String, double> _wordMatch(
//       String message, Map<String, List<String>> predefinedWords) {
//     var messageLower = message.toLowerCase();
//     var matchedHeadings = <String, double>{};

//     predefinedWords.forEach((heading, words) {
//       var matchedWords = words
//           .where((word) => messageLower.contains(word.toLowerCase()))
//           .length;
//       var totalWords = words.length;
//       var percentageMatched = (matchedWords / totalWords) * 100;

//       if (percentageMatched > 0) {
//         matchedHeadings[heading] = percentageMatched;
//       }
//     });

//     return matchedHeadings;
//   }

//   double _calculateStayDuration(List<dynamic> row, List<List<dynamic>> data) {
//     // Implement the stay duration calculation logic similar to the Python code
//     // This is a placeholder implementation
//     return 15.0;
//   }
// }

// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:convert';
// import 'dart:io';

// class CsvProcessingScreen extends StatefulWidget {
//   const CsvProcessingScreen({super.key});

//   @override
//   _CsvProcessingScreenState createState() => _CsvProcessingScreenState();
// }

// class _CsvProcessingScreenState extends State<CsvProcessingScreen> {
//   List<List<dynamic>> _data = [];
//   List<Map<String, dynamic>> _processedData = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('CSV Processing'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _pickFile,
//             child: Text('Pick CSV File'),
//           ),
//           Expanded(
//             child: _data.isEmpty
//                 ? Center(child: Text('No data'))
//                 : ListView.builder(
//                     itemCount: _processedData.length,
//                     itemBuilder: (context, index) {
//                       final row = _processedData[index];
//                       return ListTile(
//                         title: Text(
//                             'User ID: ${row["User ID"]}, Latitude: ${row["Latitude"]}, Longitude: ${row["Longitude"]}'),
//                         subtitle: Text(
//                             'Matched Heading: ${row["Matched Heading"]}, Stay Duration: ${row["Stay Duration (minutes)"]} mins'),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv'],
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);
//       final input = file.openRead();
//       final fields = await input
//           .transform(utf8.decoder)
//           .transform(CsvToListConverter())
//           .toList();

//       setState(() {
//         _data = fields;
//         _processedData = _processData(fields);
//       });
//     }
//   }

//   List<Map<String, dynamic>> _processData(List<List<dynamic>> data) {
//     final predefinedWords = {
//       "Beach": ['Coast', 'Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach'],
//       "Hotel": ['Room', 'Sleep', 'Lounge', 'Booking'],
//       "Movie": ['Theater', 'watch', 'Popcorn', 'Film'],
//       "Temple": ['God', 'Prayer', 'chapel', 'church', 'worship', 'Temple'],
//     };

//     List<Map<String, dynamic>> result = [];
//     for (var row in data.skip(1)) {
//       // Skip header
//       var message = row[4]; // Assuming the message is in the 5th column
//       var matchedHeadings = _wordMatch(message.toString(), predefinedWords);

//       if (matchedHeadings.isNotEmpty) {
//         var stayDuration = _calculateStayDuration(row, data);
//         if (stayDuration > 10) {
//           result.add({
//             "User ID": row[0],
//             "Latitude": row[2],
//             "Longitude": row[3],
//             "Timestamp": row[5],
//             "Stay Duration (minutes)": stayDuration,
//             "Matched Heading": matchedHeadings.keys.join(', '),
//             "Percentage Matched": matchedHeadings.values.join(', '),
//             "Message": message,
//           });
//         }
//       }
//     }
//     return result;
//   }

//   Map<String, double> _wordMatch(
//       String message, Map<String, List<String>> predefinedWords) {
//     var messageLower = message.toLowerCase();
//     var matchedHeadings = <String, double>{};

//     predefinedWords.forEach((heading, words) {
//       var matchedWords = words
//           .where((word) => messageLower.contains(word.toLowerCase()))
//           .length;
//       var totalWords = words.length;
//       var percentageMatched = (matchedWords / totalWords) * 100;

//       if (percentageMatched > 0) {
//         matchedHeadings[heading] = percentageMatched;
//       }
//     });

//     return matchedHeadings;
//   }

//   double _calculateStayDuration(List<dynamic> row, List<List<dynamic>> data) {
//     // Implement the stay duration calculation logic similar to the Python code
//     // This is a placeholder implementation
//     return 15.0; // Assume 15 minutes for the purpose of this example
//   }
// }

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<dynamic>> _data = [];
  List<Map<String, dynamic>> _processedData = [];

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    try {
      final rawData = await rootBundle.load('assets/Final.csv');
      String content = utf8.decode(rawData.buffer.asUint8List());
      List<List<dynamic>> listData =
          const CsvToListConverter().convert(content);
      setState(() {
        _data = listData;
        print("Data loaded successfully:");
        print(_data);
        _processData();
      });
    } catch (e) {
      print("Error loading CSV file: $e");
      // Handle error loading CSV file
    }
  }

  void _processData() {
    Map<String, List<String>> predefinedWords = {
      "Beach": ['Coast', 'Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach'],
      "Hotel": ['Room', 'Sleep', 'Lounge', 'Booking'],
      "Movie": ['Theater', 'watch', 'Popcorn', 'Film'],
      "Temple": ['God', 'Prayer', 'chapel', 'church', 'worship', 'Temple']
    };

    List<Map<String, dynamic>> processedData = [];

    for (var row in _data.skip(1)) {
      // skip the header row if exists
      String message = row[6].toString();
      Map<String, double> matchedHeadings = wordMatch(message, predefinedWords);

      if (matchedHeadings.isNotEmpty) {
        processedData.add({
          "User": row[6],
          "Time": row[4],
          "Latitude": row[1],
          "Longitude": row[2],
          "Message": message,
          "Matched Headings": matchedHeadings,
        });
      }
    }

    print("Processed data:");
    print(processedData);

    processedData.sort((a, b) {
      int userComparison = a["User"].compareTo(b["User"]);
      if (userComparison != 0) return userComparison;
      int timeComparison = DateFormat('HH:mm:ss')
          .parse(a["Time"])
          .compareTo(DateFormat('HH:mm:ss').parse(b["Time"]));
      if (timeComparison != 0) return timeComparison;
      int latComparison = a["Latitude"].compareTo(b["Latitude"]);
      if (latComparison != 0) return latComparison;
      return a["Longitude"].compareTo(b["Longitude"]);
    });

    setState(() {
      _processedData = processedData;
      print("Final processed data:");
      print(_processedData);
    });
  }

  Map<String, double> wordMatch(
      String message, Map<String, List<String>> predefinedWords) {
    String messageLower = message.toLowerCase();
    Map<String, double> matchedHeadings = {};
    predefinedWords.forEach((heading, words) {
      int matchedWords = words
          .where((word) => messageLower.contains(word.toLowerCase()))
          .length;
      double percentageMatched = (matchedWords / words.length) * 100;
      if (percentageMatched > 0) {
        matchedHeadings[heading] = percentageMatched;
      }
    });
    return matchedHeadings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processed Data'),
      ),
      body: _data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _processedData.length,
              itemBuilder: (context, index) {
                var data = _processedData[index];
                return ListTile(
                  title: Text(data["Message"]),
                  subtitle:
                      Text('Matched Headings: ${data["Matched Headings"]}'),
                );
              },
            ),
    );
  }
}








// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:csv/csv.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class TravelSummaryScreen extends StatefulWidget {
//   const TravelSummaryScreen({super.key});

//   @override
//   _TravelSummaryScreenState createState() => _TravelSummaryScreenState();
// }

// class _TravelSummaryScreenState extends State<TravelSummaryScreen> {
//   List<Map<String, dynamic>> _summarizedData = [];
//   final predefinedWords = {
//     "Beach": ['Coast', 'Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach'],
//     "Hotel": ['Room', 'Sleep', 'Lounge', 'Booking'],
//     "Movie": ['Theater', 'watch', 'Popcorn', 'Film'],
//     "Temple": ['God', 'Prayer', 'chapel', 'church', 'worship', 'Temple']
//   };

//   @override
//   void initState() {
//     super.initState();
//     loadCSV();
//   }

//   Future<void> loadCSV() async {
//     final rawData = await rootBundle.loadString("assets/Twitter Data.csv");
//     List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
//     final header = listData[0];
//     final data = listData.sublist(1);

//     final messagesColumnIndex = header.indexOf("Tweet");
//     final userIdColumnIndex = header.indexOf("USER ID");

//     final List<Map<String, dynamic>> tempSummarizedData = [];

//     for (var row in data) {
//       final userId = row[userIdColumnIndex];
//       final message = row[messagesColumnIndex];
//       final matchedHeadings = wordMatch(message, predefinedWords);

//       matchedHeadings.forEach((heading, percentageMatched) {
//         tempSummarizedData.add({
//           'User ID': userId,
//           'Matched Heading': heading,
//           'Percentage Matched': percentageMatched,
//           'Message': message
//         });
//       });
//     }

//     setState(() {
//       _summarizedData = tempSummarizedData;
//     });
//   }

//   Map<String, double> wordMatch(
//       String message, Map<String, List<String>> predefinedWords) {
//     if (message.isEmpty) return {};
//     final messageLower = message.toLowerCase();
//     final Map<String, double> matchedHeadings = {};

//     predefinedWords.forEach((heading, words) {
//       final matchedWords = words
//           .where((word) => messageLower.contains(word.toLowerCase()))
//           .length;
//       final totalWords = words.length;
//       final percentageMatched = (matchedWords / totalWords) * 100;
//       if (percentageMatched > 0) {
//         matchedHeadings[heading] = percentageMatched;
//       }
//     });

//     return matchedHeadings;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Travel Summary'),
//       ),
//       body: _summarizedData.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _summarizedData.length,
//               itemBuilder: (context, index) {
//                 final data = _summarizedData[index];
//                 return ListTile(
//                   title: Text('User: ${data['User ID']}'),
//                   subtitle: Text(
//                       'Matched Heading: ${data['Matched Heading']} (${data['Percentage Matched']}%)\nMessage: ${data['Message']}'),
//                 );
//               },
//             ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:csv/csv.dart';
// // import 'package:flutter/services.dart' show rootBundle;

// // class TravelSummaryScreen extends StatefulWidget {
// //   const TravelSummaryScreen({super.key});

// //   @override
// //   _TravelSummaryScreenState createState() => _TravelSummaryScreenState();
// // }

// // class _TravelSummaryScreenState extends State<TravelSummaryScreen> {
// //   List<List<dynamic>> _data = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadCSV();
// //   }

// //   Future<void> loadCSV() async {
// //     final rawData = await rootBundle.loadString("assets/Final.csv");
// //     List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
// //     setState(() {
// //       _data = listData;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Travel Summary'),
// //       ),
// //       body: _data.isEmpty
// //           ? const Center(child: CircularProgressIndicator())
// //           : ListView.builder(
// //               itemCount: _data.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   title: Text(_data[index].join(', ')), // Display CSV rows
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }
