import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart'; // Import your UserProvider
import 'package:google_fonts/google_fonts.dart'; // Ensure you have this for Google Fonts
import 'package:intl/intl.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';

class UpcomingEventsPage extends StatelessWidget {
  const UpcomingEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Upcoming Events'),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false).fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading events'));
          } else {
            return _buildUpcomingEvents(context);
          }
        },
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final userProvider = Provider.of<UserProvider>(context);
    final events = userProvider.events;

    if (events.isEmpty) {
      return const Center(child: Text('No upcoming events.'));
    }

    return Stack(
      children: [
        Image.network(
          'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiEg62d0UrjLE0V2YD8FZe0UWVnXF6Ru3X5l8hgffVWNPjnL0HGWkM3frdgbHdub5gPQXXZ5cSg0n3RNNwABYgHuobFgNWvrcWLJSHOoBOShEE60KX3RMLEH0dohK74MRPeX_TiJNX0Lb8/s1600/collage.jpg', // Replace with your image URL
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          color: Colors.black.withOpacity(0.2),
        ),
        SingleChildScrollView(
          child: Column(
            children: events.map((event) {
              DateTime startDate = DateTime.parse(event['start_date']);
              DateTime endDate = DateTime.parse(event['end_date']);

              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 255, 255, 0.498),
                      Color.fromARGB(255, 0, 105, 5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      event['event_name'],
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 206, 236, 169),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Place: ${event['event_place']}",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Description: ${event['description']}",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Start Date: ${dateFormat.format(startDate)}",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "End Date: ${dateFormat.format(endDate)}",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
