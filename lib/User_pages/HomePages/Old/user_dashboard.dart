import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/new_dashboard.dart';
import 'package:keralatour/Widgets/bottom_navigation.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:keralatour/Widgets/side_navigator.dart';

class DashboardScreen extends StatefulWidget {
  final int userId;
  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tour Navigator'),
      drawer: NaviBar(userId: widget.userId),
      bottomNavigationBar: TourBottomNavigator(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Most visited tourist spot',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TouristSpotCard(
                    imagePath: 'assets/images/logo.png',
                    title: 'Munnar',
                    location: 'Idukki, Kerala',
                    rating: 4.8,
                  ),
                  TouristSpotCard(
                    imagePath: 'assets/images/logo.png',
                    title: 'Wayanad',
                    location: 'Wayanad, Kerala, India',
                    rating: 4.8,
                  ),
                  TouristSpotCard(
                    imagePath: 'assets/images/logo.png',
                    title: 'Varkala Cliff',
                    location: 'Kollam, Kerala',
                    rating: 4.8,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Recommendation for you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  RecommendationCard(
                    imagePath: 'assets/images/profile.jpg',
                    title: ' Sri Padmanabha Swami',
                    location: 'Trivandrum, Kerala',
                  ),
                  RecommendationCard(
                    imagePath: 'assets/images/logo.png',
                    title: 'Athirappilly WaterFalls',
                    location: 'Thrissur, Kerala',
                  ),
                  RecommendationCard(
                    imagePath: 'assets/images/logo.png',
                    title: 'Kolukkumala',
                    location: 'Munnar, Idukki, Kerala',
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TravelAppHomePage(
                              userId: 1,
                            )),
                  );
                },
                child: const Text('Go to User Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TouristSpotCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final double rating;

  const TouristSpotCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(imagePath, height: 100, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(location),
                Text('Rating: $rating'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;

  const RecommendationCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(imagePath, height: 100, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(location),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewUserPage extends StatelessWidget {
  const NewUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
      ),
      body: const Center(
        child: Text('Welcome to the user page!'),
      ),
    );
  }
}
