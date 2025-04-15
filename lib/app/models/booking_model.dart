// booking.dart
class Booking {
  final String id;
  final String clubId;
  final String clubName;
  final String userId;
  final int pcNumber;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status;

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
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      clubId: json['club_id'],
      clubName: json['club_name'] ?? '',
      userId: json['user_id'],
      pcNumber: json['pc_number'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      status: json['status'],
    );
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
      id: json['id'],
      clubId: json['club_id'],
      pcNumber: json['pc_number'],
      description: json['description'] ?? '',
      isAvailable: json['is_available'] ?? false,
    );
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
      id: json['club_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      pricePerHour: (json['price_per_hour'] ?? 0).toDouble(),
      availablePCs: json['available_pcs'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'club_id': id,
      'name': name,
      'address': address,
      'price_per_hour': pricePerHour,
      'available_pcs': availablePCs,
    };
  }
}