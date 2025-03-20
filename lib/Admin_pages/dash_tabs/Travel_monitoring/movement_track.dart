import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';

class CoordinatesPage extends StatefulWidget {
  const CoordinatesPage({super.key});

  @override
  _CoordinatesPageState createState() => _CoordinatesPageState();
}

class _CoordinatesPageState extends State<CoordinatesPage> {
  ui.Image? backgroundImage;
  Offset _offset = Offset.zero;
  double scaleFactor = 1.0;
  Timer? _timer;
  int step = 0;

  List<Offset> path1 = [];
  List<Offset> path2 = [];

  List<Offset> traveledPath1 = [];
  List<Offset> traveledPath2 = [];

  Offset person1 = Offset.zero;
  Offset person2 = Offset.zero;

  String speedInfo1 = '';
  String directionInfo1 = '';
  String turnDegreeInfo1 = '';

  String speedInfo2 = '';
  String directionInfo2 = '';
  String turnDegreeInfo2 = '';

  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _generatePaths();
    _startAnimation();
    _startTimeUpdate();
  }

  void _loadBackgroundImage() async {
    final ByteData data = await rootBundle.load('assets/images/map.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    if (mounted) {
      setState(() {
        backgroundImage = frameInfo.image;
      });
    }
  }

  void _generatePaths() {
    final random = Random();
    double startX1 = 100, startY1 = 200;
    double startX2 = 500, startY2 = 200;

    for (int i = 0; i < 90; i++) {
      startX1 += random.nextInt(100) - 30;
      startY1 += (i % 5 == 0) ? -random.nextInt(40) : random.nextInt(60);

      startX2 += (i % 6 == 0) ? -random.nextInt(80) : random.nextInt(80);
      startY2 += (i % 8 == 0) ? -random.nextInt(60) : random.nextInt(80);

      startX1 = startX1.clamp(0, backgroundImage?.width.toDouble() ?? 1200);
      startY1 = startY1.clamp(0, backgroundImage?.height.toDouble() ?? 800);
      startX2 = startX2.clamp(0, backgroundImage?.width.toDouble() ?? 1000);
      startY2 = startY2.clamp(0, backgroundImage?.height.toDouble() ?? 800);

      path1.add(Offset(startX1, startY1));
      path2.add(Offset(startX2, startY2));
    }

    person1 = path1.first;
    person2 = path2.first;
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (step < path1.length) {
        setState(() {
          traveledPath1.add(path1[step]);
          traveledPath2.add(path2[step]);
          person1 = path1[step];
          person2 = path2[step];

          _updateMovementInfo(step);
          step++;
        });
      } else {
        step = 0;
        traveledPath1.clear();
        traveledPath2.clear();
      }
    });
  }

  void _startTimeUpdate() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  void _updateMovementInfo(int step) {
    final random = Random();

    double speed1 = 10 + random.nextDouble() * 80;
    speedInfo1 = "${speed1.toStringAsFixed(2)} km/h";

    double speed2 = 10 + random.nextDouble() * 80;
    speedInfo2 = "${speed2.toStringAsFixed(2)} km/h";

    directionInfo1 = _convertAngleToDirection(random.nextDouble() * 360);
    directionInfo2 = _convertAngleToDirection(random.nextDouble() * 360);

    if (step > 0) {
      turnDegreeInfo1 = _calculateTurnDegree(path1[step], path1[step - 1]);
      turnDegreeInfo2 = _calculateTurnDegree(path2[step], path2[step - 1]);
    }
  }

  String _convertAngleToDirection(double angle) {
    if (angle >= 0 && angle < 45) {
      return 'North';
    } else if (angle >= 45 && angle < 135) {
      return 'East';
    } else if (angle >= 135 && angle < 225) {
      return 'South';
    } else {
      return 'West';
    }
  }

  String _calculateTurnDegree(Offset current, Offset previous) {
    double dx = current.dx - previous.dx;
    double dy = current.dy - previous.dy;
    double angle = (atan2(dy, dx) * 180 / pi).abs();
    return "${angle.toStringAsFixed(0)}°";
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (backgroundImage == null) return;

    double scaledWidth = backgroundImage!.width * scaleFactor;
    double scaledHeight = backgroundImage!.height * scaleFactor;

    double maxX = 0, maxY = 0;
    double minX = -(scaledWidth - MediaQuery.of(context).size.width);
    double minY = -(scaledHeight - MediaQuery.of(context).size.height);

    setState(() {
      Offset newOffset = _offset + details.delta;
      _offset = Offset(
        newOffset.dx.clamp(minX, maxX),
        newOffset.dy.clamp(minY, maxY),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sample User Movement Tracking'),
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            child: CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: TravelPainter(backgroundImage, _offset, scaleFactor,
                  person1, person2, traveledPath1, traveledPath2),
            ),
          ),
          Positioned(
            top: 5,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildInfoBox(
                      "Sidharth", speedInfo1, directionInfo1, turnDegreeInfo1),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInfoBox(
                      "Abhijith", speedInfo2, directionInfo2, turnDegreeInfo2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    String name,
    String speed,
    String direction,
    String turnDegree,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Speed: $speed", style: const TextStyle(fontSize: 16)),
          Text("Turn Direction: $turnDegree",
              style: const TextStyle(fontSize: 16)),
          Text(
            "Date: ${_dateTime.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            "Time: ${_dateTime.toLocal().toString().split(' ')[1].split('.')[0]}",
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class TravelPainter extends CustomPainter {
  final ui.Image? backgroundImage;
  final Offset offset;
  final double scaleFactor;
  final Offset person1;
  final Offset person2;
  final List<Offset> traveledPath1;
  final List<Offset> traveledPath2;

  TravelPainter(this.backgroundImage, this.offset, this.scaleFactor,
      this.person1, this.person2, this.traveledPath1, this.traveledPath2);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    if (backgroundImage != null) {
      final double scaledWidth = backgroundImage!.width * scaleFactor;
      final double scaledHeight = backgroundImage!.height * scaleFactor;

      canvas.drawImageRect(
        backgroundImage!,
        Rect.fromLTWH(0, 0, backgroundImage!.width.toDouble(),
            backgroundImage!.height.toDouble()),
        Rect.fromLTWH(offset.dx, offset.dy, scaledWidth, scaledHeight),
        paint,
      );
    }

    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;

    // Draw traveled paths dynamically
    paint.color = Colors.red.withOpacity(0.7);
    Path pathUser1 = Path();
    if (traveledPath1.isNotEmpty) {
      pathUser1.moveTo(
          traveledPath1[0].dx + offset.dx, traveledPath1[0].dy + offset.dy);
      for (var point in traveledPath1) {
        pathUser1.lineTo(point.dx + offset.dx, point.dy + offset.dy);
      }
    }
    canvas.drawPath(pathUser1, paint);

    paint.color = Colors.blue.withOpacity(0.7);
    Path pathUser2 = Path();
    if (traveledPath2.isNotEmpty) {
      pathUser2.moveTo(
          traveledPath2[0].dx + offset.dx, traveledPath2[0].dy + offset.dy);
      for (var point in traveledPath2) {
        pathUser2.lineTo(point.dx + offset.dx, point.dy + offset.dy);
      }
    }
    canvas.drawPath(pathUser2, paint);

    // Draw moving users (circles)
    paint.style = PaintingStyle.fill;

    paint.color = Colors.red;
    canvas.drawCircle(person1 + offset, 10, paint);

    paint.color = Colors.blue;
    canvas.drawCircle(person2 + offset, 10, paint);

    // Draw names next to the dots
    const TextStyle nameTextStyle = TextStyle(
      color: Colors.red,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final TextPainter textPainter1 = TextPainter(
      text: const TextSpan(text: 'Sidharth', style: nameTextStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter1.layout();
    textPainter1.paint(
        canvas,
        person1 +
            offset +
            const Offset(12, -12)); // Position text next to the dot

    final TextPainter textPainter2 = TextPainter(
      text: TextSpan(
          text: 'Abhijith', style: nameTextStyle.copyWith(color: Colors.blue)),
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout();
    textPainter2.paint(
        canvas,
        person2 +
            offset +
            const Offset(12, -12)); // Position text next to the dot
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
