import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/controller/user_controller.dart'; // Update the path if necessary

class LiveMessage extends StatefulWidget {
  const LiveMessage({Key? key}) : super(key: key);

  @override
  State<LiveMessage> createState() => _UserMessagesState();
}

class _UserMessagesState extends State<LiveMessage> {
  late Future<List<LiveMessages>> futureSocialMedia;

  @override
  void initState() {
    super.initState();
    futureSocialMedia =
        Provider.of<UserProvider>(context, listen: false).getLiveMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Messages'),
      ),
      body: FutureBuilder<List<LiveMessages>>(
        future: futureSocialMedia,
        builder: (context, AsyncSnapshot<List<LiveMessages>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tour schedules available.'));
          } else {
            // Use nested loop to find all matching pairs
            List<LiveMessages> filteredList = [];
            for (int i = 0; i < snapshot.data!.length; i++) {
              for (int j = i + 1; j < snapshot.data!.length; j++) {
                if (snapshot.data![i].latitude == snapshot.data![j].latitude &&
                    snapshot.data![i].longitude ==
                        snapshot.data![j].longitude) {
                  if (!filteredList.contains(snapshot.data![i])) {
                    filteredList.add(snapshot.data![i]);
                  }
                  if (!filteredList.contains(snapshot.data![j])) {
                    filteredList.add(snapshot.data![j]);
                  }
                }
              }
            }

            if (filteredList.isEmpty) {
              return const Center(child: Text('No matching rows found.'));
            }

            List<LiveMessages> matchedSet1 = _filterByKeywords(filteredList,
                ['Coast', 'Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach']);

            List<LiveMessages> matchedSet2 = _filterByKeywords(
                filteredList, ['Theater', 'class', 'Popcorn', 'Film']);

            List<LiveMessages> matchedSet3 = _filterByKeywords(filteredList,
                ['God', 'Prayer', 'chapel', 'church', 'worship', 'Temple']);

            List<LiveMessages> matchedSet4 = _filterByKeywords(
                filteredList, ['Room', 'Sleep', 'drinking', 'Booking']);

            List<_TileData> allMatches = [
              ..._buildTileData(matchedSet1, 'Beach'),
              ..._buildTileData(matchedSet2, 'Movie Theatre'),
              ..._buildTileData(matchedSet3, 'Temple'),
              ..._buildTileData(matchedSet4, 'Hotel'),
            ];

            return ListView.builder(
              itemCount: allMatches.length,
              itemBuilder: (context, index) {
                return FutureBuilder<void>(
                  future: Future.delayed(Duration(seconds: index * 6)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    } else {
                      final tileData = allMatches[index];

                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(
                            'There is a ${tileData.matchingPercentage.toStringAsFixed(2)}% chance that ${tileData.socialMedia.user} has stopped at "${tileData.socialMedia.latitude}° N, ${tileData.socialMedia.longitude}° E" due to the presence of ${tileData.matchedHeading}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  List<LiveMessages> _filterByKeywords(
      List<LiveMessages> list, List<String> keywords) {
    return list
        .where((socialMedia) =>
            _containsSpecificWords(socialMedia.messages, keywords))
        .toList();
  }

  List<_TileData> _buildTileData(
      List<LiveMessages> list, String matchedHeading) {
    List<String> keywords = _getKeywordsForHeading(matchedHeading);

    return list.map((socialMedia) {
      double matchingPercentage =
          _calculateMatchingPercentage(socialMedia.messages, keywords);

      return _TileData(
        socialMedia: socialMedia,
        matchedHeading: matchedHeading,
        matchingPercentage: matchingPercentage,
      );
    }).toList();
  }

  List<String> _getKeywordsForHeading(String heading) {
    if (heading == 'Beach') {
      return ['Coast', 'Sunset', 'Walk', 'Waves', 'Sand', 'Ocean', 'Beach'];
    } else if (heading == 'Movie Theatre') {
      return ['Theater', 'class', 'Popcorn', 'Film'];
    } else if (heading == 'Temple') {
      return ['God', 'Prayer', 'chapel', 'church', 'worship', 'Temple'];
    } else if (heading == 'Hotel') {
      return ['Room', 'Sleep', 'drinking', 'Booking'];
    } else {
      return [];
    }
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
    double totalWords = message.split(' ').length.toDouble();
    double matchingWords = 0.0;

    for (final word in words) {
      if (message.toLowerCase().contains(word.toLowerCase())) {
        matchingWords++;
      }
    }

    return (matchingWords / totalWords) * 100;
  }
}

class LiveMessages {
  final String latitude;
  final String longitude;
  final String speed;
  final String user;
  final String time;
  final String messages;

  LiveMessages({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.user,
    required this.time,
    required this.messages,
  });

  factory LiveMessages.fromJson(Map<String, dynamic> json) {
    return LiveMessages(
      latitude: json['Latitude'] ?? 'nothing',
      longitude: json['Longitude'] ?? 'nothing',
      time: json['Time'] ?? 'Ti',
      user: json['User'] ?? 'Nil',
      speed: json['Speed'] ?? 'speed',
      messages: json['Messages Received'] ?? 'SMS',
    );
  }
}

class _TileData {
  final LiveMessages socialMedia;
  final String matchedHeading;
  final double matchingPercentage;

  _TileData({
    required this.socialMedia,
    required this.matchedHeading,
    required this.matchingPercentage,
  });
}
