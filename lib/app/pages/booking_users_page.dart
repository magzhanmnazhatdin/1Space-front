import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/profile_model.dart';

class BookingUsersPage extends StatefulWidget {
  final String clubId;
  final String clubName;
  const BookingUsersPage({required this.clubId, required this.clubName, Key? key}) : super(key: key);

  @override
  _BookingUsersPageState createState() => _BookingUsersPageState();
}

class _BookingUsersPageState extends State<BookingUsersPage> {
  late Future<List<Profile>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadUsers();
  }

  Future<List<Profile>> _loadUsers() async {
    final token = await context.read<AuthService>().getServerToken();
    return ApiService.getBookingUsers(widget.clubId, token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clubName),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Profile>>(
        future: _future,
        builder: (context, snapshot) {
          // загрузка
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // ошибка
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          final users = snapshot.data;
          // пустой список или null
          if (users == null || users.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.event_busy, size: 64, color: Colors.white30),
                  SizedBox(height: 16),
                  Text(
                    'Пока никто не бронировал',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          }
          // список пользователей
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final p = users[index];
              return ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: Text(
                  p.profileName.isNotEmpty ? p.profileName : p.userId,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: p.bio.isNotEmpty
                    ? Text(p.bio, style: const TextStyle(color: Colors.white70))
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
