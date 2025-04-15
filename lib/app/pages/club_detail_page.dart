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
            const SnackBar(content: Text('Ошибка аутентификации', style: TextStyle(color: Colors.white))),
          );
          return;
        }

        await ApiService.updateClub(updatedClub, token);
        setState(() {
          _clubFuture = ApiService.getClub(widget.clubId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Клуб успешно обновлен', style: TextStyle(color: Colors.white))),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка обновления клуба: $e', style: const TextStyle(color: Colors.white))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о клубе', style: TextStyle(color: Colors.white)),
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
            return Center(child: Text('Ошибка: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }

          final club = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(club.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 10),
                Text('Адрес: ${club.address}', style: const TextStyle(color: Colors.white)),
                Text('Цена за час: ${club.pricePerHour} руб.', style: const TextStyle(color: Colors.white)),
                Text('Доступно компьютеров: ${club.availablePCs}', style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE2F163),
                      foregroundColor: Colors.black,
                    ),
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
      backgroundColor: Colors.grey[900],
      title: const Text('Редактировать клуб', style: TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildField(_nameController, 'Название'),
              _buildField(_addressController, 'Адрес'),
              _buildField(_priceController, 'Цена за час (руб)', isNumber: true),
              _buildField(_pcsController, 'Доступно ПК', isNumber: true),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE2F163),
            foregroundColor: Colors.black,
          ),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController controller, String labelText, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Заполните поле';
        if (isNumber) {
          final parsed = isNumber ? double.tryParse(value!) ?? int.tryParse(value!) : null;
          if (parsed == null || (parsed is num && parsed < 0)) return 'Введите корректное число';
        }
        return null;
      },
    );
  }
}