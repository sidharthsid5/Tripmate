class TourScheduleList {
  final int day;
  final int tourId;
  final int locationId;
  final String location;
  final String date;
  final int userId;

  TourScheduleList({
    required this.day,
    required this.tourId,
    required this.locationId,
    required this.location,
    required this.date,
    required this.userId,
  });

  factory TourScheduleList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    return TourScheduleList(
      day: json['DayNumber'] ?? 0,
      locationId: json['LocationID'] ?? 0,
      tourId: json['TourID'] ?? 0,
      location: json['DistrictName'] ?? 'Unknown',
      date: json['Date'] ?? 'Date',
      userId: json['UserID'] ?? 0,
    );
  }
}
