import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:provider/provider.dart';

class AdminUserListPage extends StatefulWidget {
  const AdminUserListPage({Key? key}) : super(key: key);

  @override
  State<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> {
  late Future<List<UserList>> futureFetchUsers;

  @override
  void initState() {
    super.initState();
    futureFetchUsers =
        Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel - User List'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.grey[200],
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
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
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
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                UserDetailsScreen(userId: user.userId),
                          ),
                        );
                      },
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }
          },
        ),
      ),
    );
  }
}

class UserList {
  final String lastName;
  final String email;
  final String firstName;
  final int userId;

  UserList({
    required this.lastName,
    required this.email,
    required this.firstName,
    required this.userId,
  });

  factory UserList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return UserList(
      lastName: json['ulastName'] ?? 'Unknown',
      email: json['uemail'] ?? 'Unknown',
      firstName: json['uname'] ?? 'Unknown',
      userId: json['uid'] ?? 0,
    );
  }
}

class UserDetailsScreen extends StatelessWidget {
  final int userId;

  const UserDetailsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your user details screen here.
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('Details for user ID: $userId'),
      ),
    );
  }
}
