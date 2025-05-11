// models/profile_model.dart

class Profile {
  final String userId;
  String profileName;
  String avatarUrl;
  String bio;

  Profile({
    required this.userId,
    required this.profileName,
    required this.avatarUrl,
    required this.bio,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    userId: json['user_id'] as String,
    profileName: json['profile_name'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String? ?? '',
    bio: json['bio'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'profile_name': profileName,
    'avatar_url': avatarUrl,
    'bio': bio,
  };
}
