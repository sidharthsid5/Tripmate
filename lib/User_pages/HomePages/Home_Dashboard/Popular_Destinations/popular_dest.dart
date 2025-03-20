// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/User_pages/HomePages/Old/Places/place_details.dart';
import 'package:keralatour/User_pages/HomePages/Old/Places/places.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';

class PopularDestinationPage extends StatefulWidget {
  final int userId;
  const PopularDestinationPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _PopularDestinationPageState createState() => _PopularDestinationPageState();
}

class _PopularDestinationPageState extends State<PopularDestinationPage> {
  late Future<List<TouristLocation>> futurePopularDestinations;

  @override
  void initState() {
    super.initState();
    futurePopularDestinations = Provider.of<UserProvider>(context,
            listen: false)
        .fetchPopularDestinations(); // Update method to fetch popular destinations
  }

  void _onTabTapped(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Popular Destinations'),
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            // Grid of list tiles
            FutureBuilder<List<TouristLocation>>(
              future: futurePopularDestinations,
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
                            print('Grid Item ${item.title} tapped');
                            // Navigate to detail page, show dialog, etc.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  placeId: item.placeId,
                                  title: item.title ?? 'Unknown',
                                  imageUrl: item.imageUrl ?? '',
                                  details: item.details ?? '',
                                  district: item.district ?? '',
                                ),
                              ),
                            );
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
                                      child: Image.network(
                                        item.imageUrl ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.title ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 15.0,
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
