import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class ClubsPage extends StatefulWidget {
  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  List<ComputerClub> _clubs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    setState(() => _isLoading = true);
    try {
      final clubs = await ApiService.getClubs();
      setState(() => _clubs = clubs);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки клубов: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addClub() async {
    final token = await authService.value.getServerToken();
    if (token == null) return;

    final club = ComputerClub(
      id: 'new-id-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Новый клуб',
      address: 'Новый адрес',
      pricePerHour: 100,
      availablePCs: 10,
    );

    try {
      await ApiService.createClub(club, token);
      await _loadClubs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка создания клуба: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Компьютерные клубы'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addClub,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _clubs.length,
        itemBuilder: (context, index) {
          final club = _clubs[index];
          return ListTile(
            title: Text(club.name),
            subtitle: Text('${club.address} - ${club.pricePerHour} руб/час'),
            trailing: Text('Доступно ПК: ${club.availablePCs}'),
            onTap: () {
              // Можно добавить навигацию на детальную страницу
            },
          );
        },
      ),
    );
  }
}