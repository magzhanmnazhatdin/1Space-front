// my_bookings_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  late Future<List<Booking>> _bookingsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  Future<void> _refreshBookings() async {
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthService>();
      final token = await auth.getServerToken();
      if (token != null) {
        setState(() {
          _bookingsFuture = ApiService.getUserBookings(token);
        });
      } else {
        throw Exception('Токен отсутствует');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки бронирований: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelBooking(String bookingId) async {
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthService>();
      final token = await auth.getServerToken();
      if (token != null) {
        await ApiService.cancelBooking(bookingId, token);
        await _refreshBookings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Бронирование отменено')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отмены бронирования: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои бронироasdasdasdвания')),
      body: RefreshIndicator(
        onRefresh: _refreshBookings,
        child: FutureBuilder<List<Booking>>(
          future: _bookingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            }

            final bookings = snapshot.data ?? [];
            if (bookings.isEmpty) {
              return const Center(child: Text('У вас нет активных бронирований'));
            }

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  child: ListTile(
                    title: Text('Компьютер №${booking.pcNumber}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Клуб: ${booking.clubName}'),
                        Text('С ${DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(booking.startTime)}'),
                        Text('До ${DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(booking.endTime)}'),
                        Text('Сумма: ${booking.totalPrice} руб.'),
                        Text('Статус: ${booking.status}'),
                      ],
                    ),
                    trailing: booking.status == 'active'
                        ? IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () => _cancelBooking(booking.id),
                    )
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}