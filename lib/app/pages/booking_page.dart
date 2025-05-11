// lib/pages/booking_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;

import '../models/booking_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class BookingPage extends StatefulWidget {
  final String clubId;
  final double pricePerHour;

  const BookingPage({
    Key? key,
    required this.clubId,
    required this.pricePerHour,
  }) : super(key: key);

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

  Future<void> _selectDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('ru', 'RU'),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext ctx) async {
    final picked = await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
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
      final authService = context.read<AuthService>();
      final token = await authService.getServerToken();
      if (token == null) throw Exception('Ошибка аутентификации');

      // 1) Создаём PaymentIntent на сервере
      final amountInCents = (widget.pricePerHour * _hours * 100).round();
      final clientSecret = await ApiService.createPaymentIntent(
        amount: amountInCents,
        currency: 'rub',
        token: token,
      );

      // 2) Инициализируем платёжный лист
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'OneSpace',
        ),
      );

      // 3) Показываем платёжный интерфейс
      await Stripe.instance.presentPaymentSheet();

      // 4) После успешной оплаты — создаём бронирование
      await ApiService.createBooking(
        clubId: widget.clubId,
        pcNumber: _selectedComputer!,
        startTime: startTime,
        hours: _hours,
        token: token,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Оплата и бронирование прошли успешно')),
      );
      Navigator.pop(context, true);

    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при оплате: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Бронирование компьютера')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Computer>>(
          future: _computersFuture,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Ошибка: ${snap.error}'));
            }
            final computers = snap.data ?? [];
            return ListView(
              children: [
                ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    _selectedDate == null
                        ? 'Выберите дату'
                        : DateFormat.yMMMMd('ru_RU').format(_selectedDate!),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    _selectedTime == null
                        ? 'Выберите время'
                        : _selectedTime!.format(context),
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Часов:',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: _hours,
                      iconEnabledColor: Colors.white,
                      underline: Container(),
                      // Чтобы элемент при показе всегда по-центру
                      selectedItemBuilder: (BuildContext context) {
                        return [1, 2, 3, 4, 5, 6].map<Widget>((h) {
                          return Center(
                            child: Text(
                              '$h',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList();
                      },
                      items: [1, 2, 3, 4, 5, 6].map((h) {
                        return DropdownMenuItem<int>(
                          value: h,
                          child: Text('$h'),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _hours = v);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
                  'Стоимость: ${widget.pricePerHour * _hours} руб.',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Доступные компьютеры:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                ...computers.map((c) => Card(
                  child: ListTile(
                    title: Text('Компьютер №${c.pcNumber}'),
                    subtitle: Text(c.description),
                    trailing: c.isAvailable
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.close, color: Colors.red),
                    selected: _selectedComputer == c.pcNumber,
                    onTap: c.isAvailable
                        ? () => setState(() => _selectedComputer = c.pcNumber)
                        : null,
                  ),
                )),
                const SizedBox(height: 20),
                _isBooking
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _bookComputer,
                  child: const Text('Оплатить и забронировать'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
