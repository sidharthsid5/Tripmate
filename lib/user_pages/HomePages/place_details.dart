import 'package:flutter/material.dart';
import 'package:keralatour/user_pages/HomePages/places.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/controller/user_controller.dart'; // Adjust the path based on your project structure

class DetailScreen extends StatelessWidget {
  final int placeId;

  const DetailScreen({Key? key, required this.placeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accessing the provider to get details for placeId
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),
      body: FutureBuilder<TouristLocation>(
        future: Provider.of<UserProvider>(context).fetchTouristLocationDetails(
            placeId), // Use your method to fetch details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            TouristLocation location = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Place ID: ${location.placeId}'),
                  const SizedBox(height: 20),
                  Text('Title: ${location.title ?? 'Unknown'}'),
                  const SizedBox(height: 20),
                  Text('Image URL: ${location.imageUrl ?? 'sw'}'),
                  // Add more details as needed
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
