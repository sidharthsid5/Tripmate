import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';

class ClusterAnimationPage extends StatefulWidget {
  const ClusterAnimationPage({super.key});

  @override
  _ClusterAnimationPageState createState() => _ClusterAnimationPageState();
}

class _ClusterAnimationPageState extends State<ClusterAnimationPage> {
  final int numDotsPerCluster = 30;
  final double clusterSize = 100;
  final double jitterAmount = 10;
  bool clusteringStarted = false;
  Timer? _timer;
  Random random = Random();

  late List<Dot> dots;
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange
  ];
  final List<String> clusterNames = [
    "Cluster 1",
    "Cluster 2",
    "Cluster 3",
    "Cluster 4"
  ];
  final List<Offset> clusterCenters = [
    const Offset(100, 100),
    const Offset(300, 100),
    const Offset(100, 400),
    const Offset(300, 400),
  ];

  @override
  void initState() {
    super.initState();
    _initializeDots();
    _startRandomMovement();
  }

  void _initializeDots() {
    dots = List.generate(80, (index) {
      return Dot(
        Offset(random.nextDouble() * 400, random.nextDouble() * 500),
        null,
        Colors.grey,
        null,
      );
    });
  }

  void _startRandomMovement() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!clusteringStarted) {
        setState(() {
          for (var dot in dots) {
            dot.addJitter(20);
          }
        });
      }
    });
  }

  void _startClustering() {
    clusteringStarted = true;
    _timer?.cancel();

    for (int i = 0; i < dots.length; i++) {
      int clusterIndex = i % 4;
      dots[i].targetPosition = clusterCenters[clusterIndex] +
          Offset(random.nextDouble() * clusterSize - clusterSize / 2,
              random.nextDouble() * clusterSize - clusterSize / 2);
      dots[i].finalColor = colors[clusterIndex];
    }

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        bool allReached = true;
        for (var dot in dots) {
          if (!dot.moveForward(0.01, true)) {
            allReached = false;
          }
        }

        if (allReached) {
          _timer?.cancel();
          _spawnNewDots();
        }
      });
    });
  }

  void _spawnNewDots() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        for (int i = 0; i < 5; i++) {
          int clusterIndex = random.nextInt(4);
          Offset spawnPosition = Offset(
            random.nextBool() ? -50 : 400,
            random.nextDouble() * 500,
          );

          dots.add(Dot(
            spawnPosition,
            clusterCenters[clusterIndex] +
                Offset(random.nextDouble() * clusterSize - clusterSize / 2,
                    random.nextDouble() * clusterSize - clusterSize / 2),
            Colors.grey,
            colors[clusterIndex],
          ));
        }
      });
    });

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        for (var dot in dots) {
          dot.moveForward(0.6, true);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "User Clustering"),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: ClusterPainter(
                dots, clusteringStarted, clusterCenters, clusterNames, colors),
          ),
          Positioned(
            bottom: 20, // Adjust this based on where you want the new button
            left: MediaQuery.of(context).size.width / 2 - 140,
            child: ElevatedButton(
              onPressed: () {}, // This button doesn't do anything
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set the button color to red
                minimumSize:
                    const Size(300, 50), // Make the button span across all
              ),
              child: const Text("Hybrid (Beta)",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          Positioned(
            bottom: 80,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startClustering,
                  child: const Text("K-Means"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _startClustering,
                  child: const Text("DBSCAN"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _startClustering,
                  child: const Text("BIRCH"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dot {
  Offset currentPosition;
  Offset? targetPosition;
  Color currentColor;
  Color? finalColor;
  final Random random = Random();

  Dot(this.currentPosition, this.targetPosition, this.currentColor,
      this.finalColor);

  bool moveForward(double progress, bool instantColorChange) {
    if (targetPosition == null) return false;

    currentPosition = Offset.lerp(currentPosition, targetPosition!, progress)!;

    if ((currentPosition - targetPosition!).distance < 2) {
      if (instantColorChange) currentColor = finalColor!;
      return true;
    }
    return false;
  }

  void addJitter(double amount) {
    currentPosition = Offset(
      currentPosition.dx + (random.nextDouble() * amount * 2 - amount),
      currentPosition.dy + (random.nextDouble() * amount * 2 - amount),
    );
  }
}

class ClusterPainter extends CustomPainter {
  final List<Dot> dots;
  final bool showLabels;
  final List<Offset> clusterCenters;
  final List<String> clusterNames;
  final List<Color> colors;

  ClusterPainter(this.dots, this.showLabels, this.clusterCenters,
      this.clusterNames, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (var dot in dots) {
      paint.color = dot.currentColor;
      canvas.drawCircle(dot.currentPosition, 5, paint);

      if (dot.currentColor == Colors.grey) {
        textPainter.text = const TextSpan(
          text: "User",
          style: TextStyle(color: Colors.black, fontSize: 12),
        );
        textPainter.layout();
        textPainter.paint(canvas, dot.currentPosition + const Offset(-12, 8));
      }
    }

    if (showLabels) {
      for (int i = 0; i < clusterCenters.length; i++) {
        textPainter.text = TextSpan(
          text: clusterNames[i],
          style: TextStyle(
              color: colors[i], fontSize: 16, fontWeight: FontWeight.bold),
        );
        textPainter.layout();
        textPainter.paint(
            canvas, clusterCenters[i] - Offset(textPainter.width / 2, 70));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
