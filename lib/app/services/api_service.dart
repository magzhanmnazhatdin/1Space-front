import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080'; // Замените на ваш адрес сервера

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
}

class ComputerClub {
  final String id;
  final String name;
  final String address;
  final double pricePerHour;
  final int availablePCs;

  ComputerClub({
    required this.id,
    required this.name,
    required this.address,
    required this.pricePerHour,
    required this.availablePCs,
  });

  factory ComputerClub.fromJson(Map<String, dynamic> json) {
    return ComputerClub(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      pricePerHour: (json['price_per_hour'] ?? 0).toDouble(),
      availablePCs: json['available_pcs'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'price_per_hour': pricePerHour,
      'available_pcs': availablePCs,
    };
  }
}