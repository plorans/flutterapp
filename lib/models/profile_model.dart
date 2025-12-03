class ProfileModel {
  final int id;
  final String displayName;
  final String email;
  final String avatar;
  final Map<String, dynamic>? membership;
  final double credit;
  final String creditFormatted;
  final List<dynamic> achievements;

  ProfileModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.avatar,
    this.membership,
    required this.credit,
    required this.creditFormatted,
    required this.achievements,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      displayName: json['display_name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      membership: json['membership'],
      credit: (json['credit'] != null) ? (json['credit']['amount']?.toDouble() ?? 0.0) : 0.0,
      creditFormatted: json['credit']?['formatted'] ?? '',
      achievements: json['achievements'] ?? [],
    );
  }
}
