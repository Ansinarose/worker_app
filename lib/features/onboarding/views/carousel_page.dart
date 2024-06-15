


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';

class CarouselPage extends StatelessWidget {
  const CarouselPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          // Access MediaQuery
          final mediaQuery = MediaQuery.of(context);
          
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 45, 14, 73), Color.fromARGB(255, 27, 12, 75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: mediaQuery.padding.top + 50), // Add spacing from top
                Column(
                  children: [
                    Text(
                      'ALFA Aluminium Works',
                      style: AppTextStyles.whitetext(context)),
                      SizedBox(height: 10,),
                      Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/387-3872576_purple-home-5-icon-free-icons-house-with.png'),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(height: 50), 
                      Text('Highlites of the day..',style: AppTextStyles.whitetext(context),)
                  ],
                ),
                SizedBox(height: 20), // Add spacing between heading and carousel
                Container(
                  height: mediaQuery.size.height * 0.5, // 50% of screen height
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: mediaQuery.size.height * 0.5,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                    items: [
                      // Add your carousel items here
                      _buildCarouselItem(context, 'assets/images/d6977a0d639a2ff2183e9df12823f974.jpg',),
                      _buildCarouselItem(context, 'assets/images/blue3.jpg', ),
                      _buildCarouselItem(context, 'assets/images/blue2.jpg', ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add spacing between carousel and button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/registertwo', (route) => false);
                  },
                  child: Text(
                    'Register in Detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.padding.bottom + 50), // Add spacing from bottom
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, String imagePath,) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
