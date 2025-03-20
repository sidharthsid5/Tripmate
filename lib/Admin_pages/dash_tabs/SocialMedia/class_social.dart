class SocialMedia {
  final String latitude;
  final String longitude;
  final String speed;
  final String user;
  final String time;
  final String messages;

  SocialMedia({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.user,
    required this.time,
    required this.messages,
  });

  factory SocialMedia.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return SocialMedia(
      latitude: json['Latitude'] ?? 'nothing',
      longitude: json['Longitude'] ?? 'nothing',
      time: json['Time'] ?? 'Ti',
      user: json['User'] ?? 'Nil',
      speed: json['Speed'] ?? 'speed',
      messages: json['Messages Received'] ?? 'SMS',
    );
  }
}
