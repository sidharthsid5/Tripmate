import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/User/user_list.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:provider/provider.dart';
// Import the UserDetailsScreen

class RecentUsersPage extends StatefulWidget {
  const RecentUsersPage({Key? key}) : super(key: key);

  @override
  State<RecentUsersPage> createState() => _RecentUsersPageState();
}

class _RecentUsersPageState extends State<RecentUsersPage> {
  late Future<List<UserList>> futureFetchUsers;

  @override
  void initState() {
    super.initState();
    // Fetching the user list
    futureFetchUsers =
        Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context)
            .scaffoldBackgroundColor, // Match theme background color
        child: FutureBuilder<List<UserList>>(
          future: futureFetchUsers,
          builder: (context, AsyncSnapshot<List<UserList>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(child: Text('No users found.'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color:
                        Theme.of(context).cardColor, // Match theme card color
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary, // Match theme accent color
                        child: Text(
                          user.firstName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(user: user),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
