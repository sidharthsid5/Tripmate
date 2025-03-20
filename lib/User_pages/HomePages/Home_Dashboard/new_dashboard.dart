import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/Upcoming_events/events_display.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/Popular_Destinations/popular_dest.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/View_Schedule/schdule_new.dart';
import 'package:keralatour/User_pages/HomePages/Old/Places/place_details.dart';
import 'package:keralatour/User_pages/HomePages/Old/Places/places.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/Add_Schedule/interest_page.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:keralatour/Widgets/side_navigator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:provider/provider.dart';

class TravelAppHomePage extends StatefulWidget {
  final int userId;

  const TravelAppHomePage({super.key, required this.userId});

  @override
  _TravelAppHomePageState createState() => _TravelAppHomePageState();
}

class _TravelAppHomePageState extends State<TravelAppHomePage> {
  String temperature = '';
  String description = '';
  String iconUrl = '';
  String windSpeed = '';
  String humidity = '';
  String feelsLike = '';
  String uvIndex = '';
  String locationName = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      Position position = await _determinePosition();
      String apiKey = '3422765e8eaf424492b71944242509';
      String weatherUrl =
          'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=${position.latitude},${position.longitude}&aqi=no';

      final weatherResponse = await http.get(Uri.parse(weatherUrl));

      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);

        setState(() {
          temperature = weatherData['current']['temp_c'].toString();
          description = weatherData['current']['condition']['text'];
          iconUrl = 'https:${weatherData['current']['condition']['icon']}';
          windSpeed = weatherData['current']['wind_kph'].toString();
          humidity = weatherData['current']['humidity'].toString();
          feelsLike = weatherData['current']['feelslike_c'].toString();
          uvIndex = weatherData['current']['uv'].toString();
          locationName = weatherData['location']['name'];
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final futurePopularDestinations =
        Provider.of<UserProvider>(context).fetchPopularDestinations();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 236, 236),
      appBar: const CustomAppBar(title: 'Welcome'),
      drawer: NaviBar(userId: widget.userId),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PopupContent(userId: widget.userId),
                        ),
                      );
                    },
                    child: _buildTransportOption(
                      'https://cdn-icons-png.flaticon.com/512/7057/7057824.png',
                      'Add Schedule',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ScheduleHistory1(userId: widget.userId),
                        ),
                      );
                    },
                    child: _buildTransportOption(
                      'https://cdn-icons-png.flaticon.com/512/6213/6213653.png',
                      'View Schedule',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpcomingEventsPage(),
                        ),
                      );
                    },
                    child: _buildEventsTile(
                      'https://img.freepik.com/premium-vector/upcoming-events-speech-bubble-banner-with-upcoming-events-text-glassmorphism-style-business-marketing-advertising-vector-isolated-background-eps-10_399089-2079.jpg?w=1800',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Popular Destination',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 133, 3, 3))),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PopularDestinationPage(
                                userId: widget.userId,
                              )),
                    );
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            FutureBuilder<List<TouristLocation>>(
              future: futurePopularDestinations,
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
                          const Duration(milliseconds: 300),
                      viewportFraction: 0.8,
                    ),
                    items: snapshot.data!.map((item) {
                      return GestureDetector(
                        onTap: () {
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
                        child: Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 0.50),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                  item.imageUrl ?? 'u',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Weather Forecast',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 77, 164, 223),
                ),
              ),
            ),
            const SizedBox(height: 5),
            _buildWeatherTile(
              temperature,
              description,
              iconUrl,
              windSpeed,
              humidity,
              feelsLike,
              uvIndex,
              locationName,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportOption(String imageUrl, String label) {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 196, 61, 61),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Image.network(
              imageUrl,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color.fromARGB(255, 48, 0, 0),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsTile(String imageUrl) {
    return Column(
      children: [
        Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherTile(
    String temperature,
    String description,
    String iconUrl,
    String windSpeed,
    String humidity,
    String feelsLike,
    String uvIndex,
    String locationName,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Stormclouds.jpg/250px-Stormclouds.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: const Color.fromARGB(20, 0, 0, 0),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location: $locationName',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Temperature: $temperature °C',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Condition: $description',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'Feels Like: $feelsLike °C',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'Wind Speed: $windSpeed kph',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'Humidity: $humidity%',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'UV Index: $uvIndex',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Image.network(
                        iconUrl,
                        width: 50,
                        height: 40,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const CircularProgressIndicator(); // Placeholder while loading
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error,
                              color: Colors.white); // Error icon
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _fetchWeatherData,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
