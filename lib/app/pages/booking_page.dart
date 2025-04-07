// booking_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/booking_model.dart';

class BookingPage extends StatefulWidget {
  final String clubId;

  const BookingPage({required this.clubId, Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late Future<List<Computer>> _computersFuture;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedComputer;
  int _hours = 1;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _computersFuture = ApiService.getClubComputers(widget.clubId);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _bookComputer() async {
    if (_selectedDate == null || _selectedTime == null || _selectedComputer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    final startTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (startTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нельзя забронировать на прошедшее время')),
      );
      return;
    }

    setState(() => _isBooking = true);
    try {
      // Получаем AuthService через Provider
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = await authService.getServerToken();

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка аутентификации')),
        );
        return;
      }

      await ApiService.createBooking(
        clubId: widget.clubId,
        pcNumber: _selectedComputer!,
        startTime: startTime,
        hours: _hours,
        token: token,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Бронирование успешно создано')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка бронирования: $e')),
      );
    } finally {
      setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Бронирование компьютера')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Computer>>(
          future: _computersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            }

            final computers = snapshot.data!;
            return ListView(
              children: [
                // Выбор даты и времени
                ListTile(
                  title: Text(_selectedDate == null
                      ? 'Выберите дату'
                      : DateFormat.yMMMMd('ru_RU').format(_selectedDate!)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                ListTile(
                  title: Text(_selectedTime == null
                      ? 'Выберите время'
                      : _selectedTime!.format(context)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),

                // Выбор количества часов
                Row(
                  children: [
                    const Text('Количество часов:'),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: _hours,
                      items: [1, 2, 3, 4, 5, 6].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _hours = value);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text('Доступные компьютеры:', style: TextStyle(fontSize: 16)),

                // Список компьютеров
                ...computers.map((computer) => Card(
                  child: ListTile(
                    title: Text('Компьютер №${computer.number}'),
                    subtitle: Text(computer.description),
                    trailing: computer.isAvailable
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.close, color: Colors.red),
                    selected: _selectedComputer == computer.number,
                    onTap: computer.isAvailable
                        ? () => setState(() => _selectedComputer = computer.number)
                        : null,
                  ),
                )),

                const SizedBox(height: 20),
                _isBooking
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _bookComputer,
                  child: const Text('Забронировать'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}