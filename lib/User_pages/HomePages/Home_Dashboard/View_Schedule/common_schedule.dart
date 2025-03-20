class TourSchedule {
  final int scheduleId;
  final int duration;
  final String location;
  final double distance;
  final String time;
  final String category;
  final String imageUrl;
  final String district;

  TourSchedule({
    required this.scheduleId,
    required this.duration,
    required this.location,
    required this.distance,
    required this.time,
    required this.category,
    required this.imageUrl,
    required this.district,
  });

  factory TourSchedule.fromJson(Map<String, dynamic> json) {
    return TourSchedule(
        scheduleId: json['schedule_id'] ?? 0,
        duration: json['time'] ?? 0,
        location: json['location'] ?? 'nothing',
        distance: json['distance'] != null
            ? double.parse(json['distance'].toString())
            : 0.0,
        time: json['Time'] ?? 'N/A',
        category: json['category'] ?? 'Nil',
        imageUrl: json["image"] ?? 'nil',
        district: json["district "] ?? "nil");
  }
}
