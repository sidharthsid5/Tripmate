import 'package:flutter/material.dart';
import 'package:keralatour/User_pages/HomePages/Home_Dashboard/View_Schedule/common_schedule.dart';
import 'package:provider/provider.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:video_player/video_player.dart';

class TourSchedule2 extends StatefulWidget {
  final int tourId;
  final int userId;
  const TourSchedule2({Key? key, required this.tourId, required this.userId})
      : super(key: key);

  @override
  _TourSchedule2State createState() => _TourSchedule2State();
}

class _TourSchedule2State extends State<TourSchedule2>
    with TickerProviderStateMixin {
  late Future<List<TourSchedule>> futureTourSchedules;
  late AnimationController _animationController;
  late AnimationController _blinkController;
  List<GlobalKey> _locationKeys = [];
  List<Offset> _locationPositions = [];
  List<TourSchedule> _schedules = [];
  int _lastPopupIndex = -1;
  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    futureTourSchedules = Provider.of<UserProvider>(context, listen: false)
        .getTourSchedules(widget.tourId);
    _animationController = AnimationController(
      duration: const Duration(seconds: (25 + (3 * 5))),
      vsync: this,
    );
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  Future<void> _initializeAnimations(List<TourSchedule> schedules) async {
    _locationKeys = List.generate(schedules.length, (index) => GlobalKey());
    _locationPositions =
        List.generate(schedules.length, (index) => Offset.zero);
    _schedules = schedules; // Store schedules

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocationPositions();
      setState(() {
        _animationsInitialized = true;
      });
    });
  }

  void _getLocationPositions() {
    for (int i = 0; i < _locationKeys.length; i++) {
      RenderBox? renderBox =
          _locationKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _locationPositions[i] = renderBox.localToGlobal(const Offset(-20, 0));
        });
      }
    }
  }

  Future<void> _startAnimation() async {
    if (!_animationsInitialized) {
      return;
    }
    if (_locationPositions.length < 2) {
      return;
    }
    _animationController.reset();
    _lastPopupIndex = -1;
    await _animationController.forward();
  }

  void _showPlaceDetailsPopup(TourSchedule schedule) {
    _animationController.stop();

    String description;
    if (_locationPositions.length == 2) {
      description =
          'This location offers a peaceful getaway with scenic views, making it perfect for short trips and nature lovers.';
    } else if (_locationPositions.length == 3) {
      description =
          'A must-visit destination with diverse landscapes, suitable for adventure seekers and travelers looking for a rich experience.';
    } else {
      description =
          'Vagamon is a serene hill station situated in the Idukki district of Kerala, known for its rolling meadows, pine forests, and mist-covered hills. It offers a cool climate and a peaceful environment, perfect for trekking, paragliding, and nature walks. Vagamon is an ideal destination for those seeking tranquility and natural beauty.';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _VideoDescriptionPopup(
            locationName: schedule.location,
            videoUrl: 'assets/images/wagamon.mp4',
            description: description,
          );
        },
      ).then((_) {
        _animationController.forward(from: _animationController.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<TourSchedule>>(
        future: futureTourSchedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tour schedules available.'));
          } else {
            List<TourSchedule> schedules = snapshot.data!;
            if (!_animationsInitialized) {
              _initializeAnimations(schedules);
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _animationsInitialized ? _startAnimation : null,
                    child: const Text('Start Journey'),
                  ),
                  SizedBox(
                    height: schedules.length * 115.0,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size.infinite,
                          painter: PathPainter(
                            locationPositions: _locationPositions,
                            animation: _animationController,
                            stopDuration: 10,
                            locationCount: schedules.length,
                            blinkController: _blinkController,
                            onCarStoppedAtLocation: (index) {
                              if (index >= 0 && index < _schedules.length) {
                                if (index != _lastPopupIndex) {
                                  _showPlaceDetailsPopup(_schedules[index]);
                                  _lastPopupIndex = index;
                                } else {}
                              }
                            },
                            schedules: _schedules,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            TourSchedule schedule = schedules[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    alignment: Alignment.center,
                                  ),
                                  Container(
                                    key: _locationKeys[index],
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreen.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          schedule.location,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          '${schedule.distance.toStringAsFixed(2)} km, ${schedule.time}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          '${schedule.category}, ${schedule.duration} Hours',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _VideoDescriptionPopup extends StatefulWidget {
  final String locationName;
  final String videoUrl;
  final String description;

  const _VideoDescriptionPopup({
    Key? key,
    required this.locationName,
    required this.videoUrl,
    required this.description,
  }) : super(key: key);

  @override
  State<_VideoDescriptionPopup> createState() => _VideoDescriptionPopupState();
}

class _VideoDescriptionPopupState extends State<_VideoDescriptionPopup> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width:
            MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_controller.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            else
              const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 10),
            Text(
              widget.locationName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      insetPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      contentPadding:
          const EdgeInsets.all(16.0), // Add some padding inside the content
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final List<Offset> locationPositions;
  final Animation<double> animation;
  final int stopDuration;
  final int locationCount;
  final AnimationController blinkController;
  final Function(int) onCarStoppedAtLocation;
  final List<TourSchedule> schedules;

  PathPainter({
    required this.locationPositions,
    required this.animation,
    required this.stopDuration,
    required this.locationCount,
    required this.blinkController,
    required this.onCarStoppedAtLocation,
    required this.schedules,
  }) : super(repaint: animation);

  int _lastIndex = -1;
  int _popupTriggeredIndex = -1;
  @override
  void paint(Canvas canvas, Size size) {
    if (locationPositions.length < 2) return;

    final paint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < locationPositions.length - 1; i++) {
      canvas.drawLine(locationPositions[i], locationPositions[i + 1], paint);
    }

    double adjustedValue = animation.value * locationCount;
    int index = adjustedValue.floor();
    double localT = adjustedValue % 1;

    double carSize = 12 + (3 * (1 - localT));

    // PRINT STATEMENT

    if (index < locationPositions.length - 1) {
      if (localT < 0.7) {
        Offset currentPosition = Offset.lerp(locationPositions[index],
            locationPositions[index + 1], localT / 0.7)!;
        _drawCarIcon(canvas, currentPosition, carSize);
      } else {
        _drawCarIcon(canvas, locationPositions[index + 1], carSize);
      }
    } else if (index < locationPositions.length) {
      _drawCarIcon(canvas, locationPositions[index], carSize);
    }

    // Detect stop and trigger popup
    if (index > _lastIndex && index < locationPositions.length) {
      if (index > 0) {
        // Avoid triggering popup at the start
        if (index != _popupTriggeredIndex) {
          // Trigger popup only once per index
          // PRINT STATEMENT
          onCarStoppedAtLocation(index);
          _popupTriggeredIndex = index; // Update popup triggered index
        } else {
          // PRINT STATEMENT
        }
      } else {
        // PRINT STATEMENT
      }
      _lastIndex = index;
    }
  }

  void _drawCarIcon(Canvas canvas, Offset position, double size) {
    double blinkScale = 2.0 + blinkController.value * 0.9;
    double finalSize = size * blinkScale;

    const icon = Icons.directions_car;
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: finalSize,
          fontFamily: icon.fontFamily,
          color: Colors.redAccent,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// class DetailScreen extends StatelessWidget {
//   final int placeId;
//   final String title;
//   final String imageUrl;
//   final String details;
//   final String district;

//   const DetailScreen({
//     required this.placeId,
//     required this.title,
//     required this.imageUrl,
//     Key? key,
//     required this.details,
//     required this.district,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print("DetailScreen build method called for: $title"); // PRINT STATEMENT
//     return Container(
//       // Changed from Scaffold to Container for AlertDialog content
//       width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min, // Important for AlertDialog
//           children: [
//             // Top Image with Back Button - Removed Back Button as it's in Dialog
//             Stack(
//               children: [
//                 Container(
//                   height: 200, // Adjusted height for popup
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(imageUrl),
//                       fit: BoxFit.cover,
//                     ),
//                     borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(10)), // Rounded top corners
//                   ),
//                 ),
//                 // Gradient overlay for better text visibility
//                 Container(
//                   height: 200, // Adjusted height for popup
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(10)), // Rounded top corners
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.black.withOpacity(0.5),
//                         Colors.black.withOpacity(0.0),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10, // Adjusted position
//                   left: 10, // Adjusted position
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 24, // Adjusted font size for popup
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           shadows: [
//                             Shadow(
//                               offset: Offset(1.5, 1.5),
//                               blurRadius: 3.0,
//                               color: Colors.black,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         '$district District, Kerala',
//                         style: const TextStyle(
//                           fontSize: 14, // Adjusted font size for popup
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           shadows: [
//                             Shadow(
//                               offset: Offset(1.5, 1.5),
//                               blurRadius: 0.01,
//                               color: Colors.black,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10), // Adjusted spacing
//             Padding(
//               padding: const EdgeInsets.all(10.0), // Adjusted padding
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Description',
//                     style: TextStyle(
//                       fontSize: 20, // Adjusted font size for popup
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                   ),
//                   const SizedBox(height: 8), // Adjusted spacing
//                   Text(
//                     details,
//                     textAlign: TextAlign.justify,
//                     style: const TextStyle(
//                       fontSize: 16, // Adjusted font size for popup
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Close', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
