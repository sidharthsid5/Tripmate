import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with actual user data retrieval logic
    String username = "John Doe";
    List<String> tourPlans = [
      "Plan 1",
      "Plan 2",
      "Plan 3"
    ]; // Example tour plans

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Tour Plans:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: tourPlans.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tourPlans[index]),
                    subtitle:
                        const Text('Location: XYZ'), // Replace with actual data
                    onTap: () {
                      // Navigate to tour plan details page
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new tour plan action
        },
        tooltip: 'Add Tour Plan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
