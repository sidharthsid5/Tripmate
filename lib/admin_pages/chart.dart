import 'package:flutter/material.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:provider/provider.dart';

class TouristDetailScreen extends StatefulWidget {
  const TouristDetailScreen({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TouristDetailScreen> {
  late Future<List<TouristDetail>> futureTouristDetails;

  @override
  void initState() {
    super.initState();
    futureTouristDetails =
        Provider.of<UserProvider>(context, listen: false).fetchTouristDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            FutureBuilder<List<TouristDetail>>(
              future: futureTouristDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0, // Spacing between the columns
                      mainAxisSpacing: 10.0, // Spacing between the rows
                      children: snapshot.data!.map((item) {
                        return GestureDetector(
                          onTap: () {
                            // Handle tap on Grid Item
                            print('Grid Item ${item.userid} tapped');
                            // Navigate to detail page, show dialog, etc.
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         DetailScreen(placeId: item.placeId),
                            //   ),
                            // );
                          },
                          child: GridTile(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Text(
                                        item.country ?? '',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.userid ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      selectionColor: Colors.red,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      item.sex ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      selectionColor: Colors.red,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      item.age ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 5.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      selectionColor: Colors.red,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      item.year ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 5.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      selectionColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TouristDetail {
  final String? age;
  final String? userid;
  final String? country;
  final String? sex;
  final String? year;

  TouristDetail(this.age, this.userid, this.country, this.sex, this.year);

  factory TouristDetail.fromJson(Map<String, dynamic> json) {
    return TouristDetail(
      json['Age'] ?? 0,
      json['UserID'],
      json['Country'],
      json['Sex'],
      json['Year of Visit'],
    );
  }
}
