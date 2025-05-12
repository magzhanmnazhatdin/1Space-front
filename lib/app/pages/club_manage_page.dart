import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'club_detail_page.dart';
import 'booking_users_page.dart';

class ClubManagePage extends StatefulWidget {
  const ClubManagePage({Key? key}) : super(key: key);

  @override
  _ClubManagePageState createState() => _ClubManagePageState();
}

class _ClubManagePageState extends State<ClubManagePage> {
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
      final all = await ApiService.getClubs();
      final authService = context.read<AuthService>();
      List<ComputerClub> clubs;
      if (authService.isAdmin) {
        // админ видит все
        clubs = all;
      } else {
        // менеджер видит только свои
        final uid = authService.currentUser?.uid;
        clubs = all.where((c) => c.managerId == uid).toList();
      }

      setState(() => _clubs = clubs);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки клубов: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  Future<void> _addClub() async {
    final authService = context.read<AuthService>();
    if (!authService.isAdmin && !authService.isManager) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('У вас нет прав для создания клуба')),
      );
      return;
    }
    final token = await authService.getServerToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка аутентификации')),
      );
      return;
    }
    final club = ComputerClub(
      id: '',
      name: 'Новый клуб',
      address: 'Новый адрес',
      pricePerHour: 100,
      availablePCs: 10,
    );
    try {
      String? managerId;
      if (authService.isAdmin) managerId = authService.currentUser?.uid;
      await ApiService.createClub(club, token, managerId: managerId);
      await _loadClubs();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Клуб успешно создан')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка создания клуба: $e')),
      );
    }
  }

  Future<void> _editClub(ComputerClub club) async {
    final authService = context.read<AuthService>();
    if (!authService.isAdmin && !authService.isManager) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('У вас нет прав для редактирования клуба')),
      );
      return;
    }
    final updated = await showDialog<ComputerClub>(
      context: context,
      builder: (_) => EditClubDialog(club: club),
    );
    if (updated != null) {
      try {
        final token = await authService.getServerToken();
        if (token == null) throw Exception('Не авторизован');
        await ApiService.updateClub(updated, token);
        await _loadClubs();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Клуб успешно обновлен')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка обновления клуба: $e')),
        );
      }
    }
  }

  Future<void> _deleteClub(ComputerClub club) async {
    final authService = context.read<AuthService>();
    if (!authService.isAdmin && !authService.isManager) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('У вас нет прав для удаления клуба')),
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Подтвердите удаление'),
        content: Text('Удалить клуб "${club.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Удалить')),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final token = await authService.getServerToken();
        if (token == null) throw Exception('Не авторизован');
        await ApiService.deleteClub(club.id, token);
        await _loadClubs();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Клуб удален')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления клуба: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final canManage = authService.isAdmin || authService.isManager;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFE2F163)),
        actionsIconTheme: const IconThemeData(color: Color(0xFFE2F163)),
        title: const Text(
          'Manage Clubs',
          style: TextStyle(color: Color(0xFFE2F163)),
        ),
        actions: [
          if (canManage)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addClub,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
        itemCount: _clubs.length,
        itemBuilder: (ctx, i) {
          final club = _clubs[i];
          return ListTile(
            title: Text(club.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              '${club.address} - ${club.pricePerHour} руб/час',
              style: const TextStyle(color: Colors.white70),
            ),
            // Теперь при тапе на строку открываем компьютеры клуба
            onTap: canManage
                ? () {
              Navigator.pushNamed(
                context,
                '/club-computers',
                arguments: club,
              );
            }
                : null,
            trailing: canManage
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _editClub(club),
                ),
                IconButton(
                  icon: const Icon(Icons.event_busy, color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingUsersPage(
                        clubId: club.id,
                        clubName: club.name,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _deleteClub(club),
                ),
              ],
            )
                : null,
          );

        },
      ),
    );
  }
}
