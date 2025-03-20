import 'package:flutter/material.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';

class ImageGalleryPage extends StatelessWidget {
  const ImageGalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isWeb = identical(0, 0.0); // Detects if running on Web
    double imageHeight = isWeb ? 500 : 300;
    double imageWidth = isWeb ? 800 : double.infinity;

    List<String> images = [
      'assets/images/n1.png',
      'assets/images/n2.png',
      'assets/images/n3.png',
      'assets/images/n4.png',
      'assets/images/n5.png',
      'assets/images/n6.png',
      'assets/images/n7.png',
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Tourist Statistics '),
      body: SingleChildScrollView(
        child: Column(
          children: images.map((imagePath) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain, // Ensures full image is visible
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
