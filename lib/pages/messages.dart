import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class MyHomePages extends StatefulWidget {
  const MyHomePages({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePages> {
  List<List<dynamic>> _data = [];
  List<Map<String, dynamic>> _processedData = [];

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    try {
      final rawData = await rootBundle.load('assets/Final2.csv');
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
      if (row.length >= 5) {
        // Adjust this condition based on your actual CSV structure
        String message =
            row[5].toString(); // Assuming the message is in the 9th column
        Map<String, double> matchedHeadings =
            wordMatch(message, predefinedWords);

        if (matchedHeadings.isNotEmpty) {
          processedData.add({
            "User": row[4],
            "Time": row[2],
            "Latitude": row[0],
            "Longitude": row[1],
            "Message": message,
            "Matched Headings": matchedHeadings,
          });
        }
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
      double latA = double.parse(a["Latitude"].toString());
      double latB = double.parse(b["Latitude"].toString());
      int latComparison = latA.compareTo(latB);
      if (latComparison != 0) return latComparison;
      double longA = double.parse(a["Longitude"].toString());
      double longB = double.parse(b["Longitude"].toString());
      return longA.compareTo(longB);
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
