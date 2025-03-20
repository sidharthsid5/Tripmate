import 'package:flutter/material.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      appBar: const CustomAppBar(title: 'User List'),
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
                itemCount: snapshot.data!.length,
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditUserScreen(user: user),
                                ),
                              )
                                  .then((_) {
                                setState(() {
                                  futureFetchUsers = Provider.of<UserProvider>(
                                          context,
                                          listen: false)
                                      .fetchUsers();
                                });
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _confirmDeleteUser(context, user.userId);
                            },
                          ),
                        ],
                      ),
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

  void _confirmDeleteUser(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteUser(userId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.11.2.61:4000/deleteUser/$userId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          futureFetchUsers =
              Provider.of<UserProvider>(context, listen: false).fetchUsers();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $error')),
      );
    }
  }
}

// UserList Data Model
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

  factory UserList.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
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

// UserDetailsScreen Stateless Widget
class UserDetailsScreen extends StatelessWidget {
  final UserList user;

  const UserDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user.firstName} ${user.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'User ID: ${user.userId}',
              style: const TextStyle(fontSize: 16),
            ),
            // Add more attributes as needed
          ],
        ),
      ),
    );
  }
}

// EditUserScreen Stateful Widget for editing user
class EditUserScreen extends StatefulWidget {
  final UserList user;

  const EditUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _email;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstName = widget.user.firstName;
    _lastName = widget.user.lastName;
    _email = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _firstName,
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a first name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstName = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _lastName,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _lastName = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        // Simple email validation
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveForm,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.put(
          Uri.parse('http://10.11.2.61:4000/updateUser/${widget.user.userId}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'firstName': _firstName,
            'lastName': _lastName,
            'email': _email,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')),
          );
        } else {
          throw Exception('Failed to update user');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
