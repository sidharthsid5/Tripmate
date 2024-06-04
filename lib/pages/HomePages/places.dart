import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:keralatour/controller/user_controller.dart';
import 'package:provider/provider.dart';

class TouristPlacesScreen extends StatefulWidget {
  const TouristPlacesScreen({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TouristPlacesScreen> {
  late Future<List<TouristLocation>> futureTouristLocation;

  @override
  void initState() {
    super.initState();
    futureTouristLocation = Provider.of<UserProvider>(context, listen: false)
        .fetchTouristLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            // Slideshow at the top
            FutureBuilder<List<TouristLocation>>(
              future: futureTouristLocation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                    items: snapshot.data!.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 0.50),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                item.imageUrl ?? 'u',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 40.0),
            // Grid of list tiles
            FutureBuilder<List<TouristLocation>>(
              future: futureTouristLocation,
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

class TouristLocation {
  final String? title;
  final String? imageUrl;

  TouristLocation(this.title, this.imageUrl);

  factory TouristLocation.fromJson(Map<String, dynamic> json) {
    return TouristLocation(
      json['location'],
      json['image'],
    );
  }
}
