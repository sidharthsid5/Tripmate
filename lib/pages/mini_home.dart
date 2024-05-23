import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  final List<String> imageList = [
    'https://encrypted-tbn3.gstatic.com/licensed-image?q=tbn:ANd9GcSGEujuKj8ew_nPxbCH9fK1hMq_deGXVAGR-JbUu542ivAofBwWmNcivF90lzZfKa6XHU3XAlRxsoW3PXLwzVZh4uRU0cX1yT4VeEw0bw',
    'https://lh5.googleusercontent.com/p/AF1QipOAqrU7Mz8qR_HT54dQHO1kfpL532mofvzxmGBk=w540-h312-n-k-no',
    'https://www.pulickattilhouseboat.com/images/shikkara.jpg',
    'https://luxoticholidays.com/blog/wp-content/uploads/2023/12/varkala-beach-kerala-1.jpg',
    'https://encrypted-tbn2.gstatic.com/licensed-image?q=tbn:ANd9GcS9p_fDAx6Frxl4YuhdMM_WL2upX_mJqqVr-Ln5omuOj1eL8AGN1eWX7KoSY7d1w7sQMLGa0gMF1zzZk3CgFbJ-98nuPLJ2ou-ReRvu3w',
  ];

  final List<GridItem> gridItems = [
    GridItem('Munnar',
        'https://encrypted-tbn2.gstatic.com/licensed-image?q=tbn:ANd9GcRVDGIZ7bj-ojcFVEDxhW4tTNRvoirwxXPCTij6q2UUL0BszvZPw149EMGWYkbsyRvk2P6Xu_4YsFLfarvohSQR6CVfuTj7PUvxmEIkbg'),
    GridItem(
        'Vagamon', 'https://www.vagamon.com/userfiles/1513834928_21-12-17.jpg'),
    GridItem('Varkala Cliff',
        'https://yatramantra.com/wp-content/uploads/2020/02/Varkala-780x588.png'),
    GridItem('Arthunkal Church',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/St._Andrew%27s_Forane_Church_of_Arthunkal.jpg/1200px-St._Andrew%27s_Forane_Church_of_Arthunkal.jpg'),
    GridItem('Sree Padmanabhaswamy Temple',
        'https://www.ekeralatourism.net/wp-content/uploads/2018/01/Sri-Padmanabhaswamy-Temple.jpg'),
    GridItem('Athirappilly Water Falls',
        'https://img.onmanorama.com/content/dam/mm/en/travel/travel-news/images/2023/2/23/athirappilly-new1.jpg'),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            // Slideshow at the top
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: imageList.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 0.50),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40.0),
            // Grid of list tiles
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10.0, // Spacing between the columns
                mainAxisSpacing: 10.0, // Spacing between the rows
                children: gridItems.map((item) {
                  return GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem {
  final String title;
  final String imageUrl;

  GridItem(this.title, this.imageUrl);
}
