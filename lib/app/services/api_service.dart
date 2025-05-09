import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<String> createPaymentIntent({
    required int amount,   // in smallest currency unit, e.g. cents
    required String currency, // e.g. "rub"
    required String token,    // ваш серверный токен для авторизации
  }) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/payments/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'amount': amount,
        'currency': currency,
      }),
    );
    if (resp.statusCode != 200) {
      throw Exception('Failed to create PaymentIntent: ${resp.body}');
    }
    final data = json.decode(resp.body);
    return data['clientSecret'] as String;
  }

  // Получение всех клубов
  static Future<List<ComputerClub>> getClubs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clubs'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ComputerClub.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load clubs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading clubs: $e');
    }
  }

  // Получение клуба по ID
  static Future<ComputerClub> getClub(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clubs/$id'));

      if (response.statusCode == 200) {
        return ComputerClub.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load club: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading club: $e');
    }
  }

  // Создание клуба
  static Future<String> createClub(ComputerClub club, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/manager/clubs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(club.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['id'] as String;
      } else {
        throw Exception(
            'Failed to create club: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating club: $e');
    }
  }

  // Обновление клуба
  static Future<void> updateClub(ComputerClub club, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/manager/clubs/${club.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(club.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update club: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating club: $e');
    }
  }

  // Удаление клуба
  static Future<void> deleteClub(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/manager/clubs/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete club: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting club: $e');
    }
  }

  // Проверка аутентификации
  static Future<String> verifyAuth(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['uid'] as String;
      } else {
        throw Exception(
            'Authentication failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error verifying auth: $e');
    }
  }

  // Получение всех компьютеров
  static Future<List<Computer>> getAllComputers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/computers'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Computer.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load computers: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading computers: $e');
    }
  }

  // Получение компьютеров клуба
  static Future<List<Computer>> getClubComputers(String clubId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clubs/$clubId/computers'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Computer.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load computers: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading club computers: $e');
    }
  }

  // Создание списка компьютеров для клуба
  static Future<void> createComputers(String clubId, List<Computer> computers, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clubs/$clubId/computers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(computers.map((computer) => computer.toJson()).toList()),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Failed to create computers: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating computers: $e');
    }
  }

  // Создание бронирования
  static Future<Booking> createBooking({
    required String clubId,
    required int pcNumber,
    required DateTime startTime,
    required int hours,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'club_id': clubId,
          'pc_number': pcNumber,
          'start_time': startTime.toUtc().toIso8601String(),
          'hours': hours,
        }),
      );

      if (response.statusCode == 201) {
        return Booking.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to create booking: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

  // Получение бронирований пользователя
  static Future<List<Booking>> getUserBookings(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load bookings: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading bookings: $e');
    }
  }

  // Отмена бронирования
  static Future<void> cancelBooking(String bookingId, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/bookings/$bookingId/cancel'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to cancel booking: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error cancelling booking: $e');
    }
  }
}