import 'dart:async';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class TravelSummaryScreen extends StatefulWidget {
  const TravelSummaryScreen({super.key});

  @override
  _TravelSummaryScreenState createState() => _TravelSummaryScreenState();
}

class _TravelSummaryScreenState extends State<TravelSummaryScreen> {
  List<Map<String, dynamic>> _summarizedData = [];
  final predefinedWords = {
    "Beach": ['Coast', 'Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach'],
    "Hotel": ['Room', 'Sleep', 'Lounge', 'Booking'],
    "Movie": ['Theater', 'watch', 'Popcorn', 'Film'],
    "Temple": ['God', 'Prayer', 'chapel', 'church', 'worship', 'Temple']
  };

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final rawData = await rootBundle.loadString("assets/Twitter Data.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    final header = listData[0];
    final data = listData.sublist(1);

    final messagesColumnIndex = header.indexOf("Tweet");
    final userIdColumnIndex = header.indexOf("USER ID");

    final List<Map<String, dynamic>> tempSummarizedData = [];

    for (var row in data) {
      final userId = row[userIdColumnIndex];
      final message = row[messagesColumnIndex];
      final matchedHeadings = wordMatch(message, predefinedWords);

      matchedHeadings.forEach((heading, percentageMatched) {
        tempSummarizedData.add({
          'User ID': userId,
          'Matched Heading': heading,
          'Percentage Matched': percentageMatched,
          'Message': message
        });
      });
    }

    setState(() {
      _summarizedData = tempSummarizedData;
    });
  }

  Map<String, double> wordMatch(
      String message, Map<String, List<String>> predefinedWords) {
    if (message.isEmpty) return {};
    final messageLower = message.toLowerCase();
    final Map<String, double> matchedHeadings = {};

    predefinedWords.forEach((heading, words) {
      final matchedWords = words
          .where((word) => messageLower.contains(word.toLowerCase()))
          .length;
      final totalWords = words.length;
      final percentageMatched = (matchedWords / totalWords) * 100;
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
        title: const Text('Travel Summary'),
      ),
      body: _summarizedData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _summarizedData.length,
              itemBuilder: (context, index) {
                final data = _summarizedData[index];
                return ListTile(
                  title: Text('User: ${data['User ID']}'),
                  subtitle: Text(
                      'Matched Heading: ${data['Matched Heading']} (${data['Percentage Matched']}%)\nMessage: ${data['Message']}'),
                );
              },
            ),
    );
  }
}
