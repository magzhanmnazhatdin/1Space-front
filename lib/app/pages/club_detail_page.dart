// club_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'booking_page.dart';

class ClubDetailPage extends StatefulWidget {
  final String clubId;

  const ClubDetailPage({required this.clubId, Key? key}) : super(key: key);

  @override
  _ClubDetailPageState createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  late Future<ComputerClub> _clubFuture;

  @override
  void initState() {
    super.initState();
    _clubFuture = ApiService.getClub(widget.clubId);
  }

  Future<void> _editClub(ComputerClub club) async {
    final updatedClub = await showDialog<ComputerClub>(
      context: context,
      builder: (context) => EditClubDialog(club: club),
    );

    if (updatedClub != null) {
      try {
        final authService = context.read<AuthService>();
        final token = await authService.getServerToken();
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ошибка аутентификации')),
          );
          return;
        }

        await ApiService.updateClub(updatedClub, token);
        setState(() {
          _clubFuture = ApiService.getClub(widget.clubId);
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о клубе'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final club = await _clubFuture;
              _editClub(club);
            },
          ),
        ],
      ),
      body: FutureBuilder<ComputerClub>(
        future: _clubFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final club = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(club.name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                Text('Адрес: ${club.address}'),
                Text('Цена за час: ${club.pricePerHour} руб.'),
                Text('Доступно компьютеров: ${club.availablePCs}'),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(clubId: club.id),
                        ),
                      );

                      if (result == true) {
                        setState(() {
                          _clubFuture = ApiService.getClub(widget.clubId);
                        });
                      }
                    },
                    child: const Text('Забронировать компьютер'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditClubDialog extends StatefulWidget {
  final ComputerClub club;

  const EditClubDialog({required this.club, Key? key}) : super(key: key);

  @override
  _EditClubDialogState createState() => _EditClubDialogState();
}

class _EditClubDialogState extends State<EditClubDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _pcsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.club.name);
    _addressController = TextEditingController(text: widget.club.address);
    _priceController = TextEditingController(text: widget.club.pricePerHour.toString());
    _pcsController = TextEditingController(text: widget.club.availablePCs.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _pcsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать клуб'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) => value?.isEmpty ?? true ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Адрес'),
                validator: (value) => value?.isEmpty ?? true ? 'Введите адрес' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Цена за час (руб)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Введите цену';
                  final price = double.tryParse(value!);
                  if (price == null || price <= 0) return 'Цена должна быть больше 0';
                  return null;
                },
              ),
              TextFormField(
                controller: _pcsController,
                decoration: const InputDecoration(labelText: 'Доступно ПК'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Введите количество ПК';
                  final pcs = int.tryParse(value!);
                  if (pcs == null || pcs < 0) return 'Количество ПК не может быть отрицательным';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final updatedClub = ComputerClub(
                id: widget.club.id,
                name: _nameController.text,
                address: _addressController.text,
                pricePerHour: double.parse(_priceController.text),
                availablePCs: int.parse(_pcsController.text),
              );
              Navigator.pop(context, updatedClub);
            }
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}