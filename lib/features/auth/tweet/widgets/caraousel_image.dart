import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:the_iconic/theme/pallete.dart';

class CaraouselImage extends StatefulWidget {
  List<String> imageLinks = [];
  CaraouselImage({super.key, required this.imageLinks});

  @override
  State<CaraouselImage> createState() => _CaraouselImageState();
}

class _CaraouselImageState extends State<CaraouselImage> {
  int _currentImage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map(
                (link) {
                  return Container(
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    margin: const EdgeInsets.all(
                      10,
                    ),
                    child: Image.network(
                      link,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                // if you modify the height , it can be bad according , if you remove
                // height pictures will be very very small which is worse

                height: 300,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) => setState(() {
                  _currentImage = index;
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageLinks.asMap().entries.map((e) {
                return Container(
                  height: 8,
                  width: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Pallete.greenColor
                        .withOpacity(e.key == _currentImage ? 1 : 0.3),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ],
    );
  }
}
