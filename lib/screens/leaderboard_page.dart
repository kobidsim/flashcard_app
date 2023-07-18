import 'package:flashcard_app/main.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> getUsers() async {
  List<Map<String, dynamic>> users = [];
  final data = await supabase.from("profiles").select("username, xp");

  for (var user in data) {
    users.add(user);
  }

  users.sort((a, b) => int.parse(b['xp']).compareTo(int.parse(a['xp'])));
  return users;
}

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    getUsers();
    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard")),
      body: const UserList(),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show an error message if there's an error
        } else {
          List<Map<String, dynamic>>? users = snapshot.data;
          return ListView.builder(
            itemCount: users?.length ?? 0,
            itemBuilder: (context, index) {
              final theme = Theme.of(context);
              return Card(
                color: theme.colorScheme.surface,
                child: ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  title: Text(
                    "${users![index]['username']}",
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  trailing: Text(
                    "${users[index]['xp']}xp",
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
