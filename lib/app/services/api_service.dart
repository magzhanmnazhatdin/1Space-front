import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/booking_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Получение всех клубов
  static Future<List<ComputerClub>> getClubs() async {
    final response = await http.get(Uri.parse('$baseUrl/clubs'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ComputerClub.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clubs');
    }
  }

  // Получение клуба по ID
  static Future<ComputerClub> getClub(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/clubs/$id'));

    if (response.statusCode == 200) {
      return ComputerClub.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load club');
    }
  }

  // Создание клуба
  static Future<String> createClub(ComputerClub club, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clubs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(club.toJson()),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body)['id'];
    } else {
      throw Exception('Failed to create club');
    }
  }

  // Обновление клуба
  static Future<void> updateClub(ComputerClub club, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clubs/${club.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(club.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update club');
    }
  }

  // Удаление клуба
  static Future<void> deleteClub(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/clubs/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete club');
    }
  }

  // Проверка аутентификации
  static Future<String> verifyAuth(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['uid'];
    } else {
      throw Exception('Authentication failed');
    }
  }

  // api_service.dart
  static Future<List<Computer>> getClubComputers(String clubId) async {
    final response = await http.get(Uri.parse('$baseUrl/clubs/$clubId/computers'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Computer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load computers');
    }
  }

  static Future<Booking> createBooking({
    required String clubId,
    required int pcNumber,
    required DateTime startTime,
    required int hours,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'club_id': clubId,
        'pc_number': pcNumber,
        'start_time': startTime.toIso8601String(),
        'hours': hours,
      }),
    );

    if (response.statusCode == 201) {
      return Booking.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create booking');
    }
  }

  static Future<List<Booking>> getUserBookings(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
  }

  static Future<void> cancelBooking(String bookingId, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/$bookingId/cancel'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel booking: ${response.statusCode}');
    }
  }
}