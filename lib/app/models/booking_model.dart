class Booking {
  final String id;
  final String clubId;
  final String clubName; // Может быть пустым, если бэкенд не вернёт
  final String userId;
  final int pcNumber;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.userId,
    required this.pcNumber,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String? ?? '',
      clubId: json['club_id'] as String? ?? '',
      clubName: json['club_name'] as String? ?? 'Unknown Club', // Заполняем значением по умолчанию
      userId: json['user_id'] as String? ?? '',
      pcNumber: json['pc_number'] as int? ?? 0,
      startTime: _parseDateTime(json['start_time']),
      endTime: _parseDateTime(json['end_time']),
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'unknown',
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  static DateTime _parseDateTime(dynamic date) {
    if (date == null) return DateTime.now();
    try {
      return DateTime.parse(date as String);
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'club_id': clubId,
      'club_name': clubName,
      'user_id': userId,
      'pc_number': pcNumber,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}

class Computer {
  final String id;
  final String clubId;
  final int pcNumber;
  final String description;
  final bool isAvailable;

  Computer({
    required this.id,
    required this.clubId,
    required this.pcNumber,
    required this.description,
    required this.isAvailable,
  });

  factory Computer.fromJson(Map<String, dynamic> json) {
    return Computer(
      id: json['id'] as String? ?? '',
      clubId: json['club_id'] as String? ?? '',
      pcNumber: json['pc_number'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      isAvailable: json['is_available'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'club_id': clubId,
      'pc_number': pcNumber,
      'description': description,
      'is_available': isAvailable,
    };
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
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      pricePerHour: (json['price_per_hour'] as num?)?.toDouble() ?? 0.0,
      availablePCs: json['available_pcs'] as int? ?? 0,
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