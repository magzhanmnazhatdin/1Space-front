// club_detail_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Информация о клубе')),
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
                Text(club.name, style: Theme.of(context).textTheme.headline5),
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