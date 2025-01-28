import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:quickfix_app/widgets/shimmer/banner_shimmer.dart';

class HomeSlider extends StatefulWidget {
  final List<dynamic> images;
  const HomeSlider({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int _current = 0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: !_isLoaded
          ? [
              const BannerShimmer(),
            ]
          : [
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  enlargeCenterPage: true,
                  aspectRatio: 1.0,
                  onPageChanged: (int page, _) {
                    setState(() {
                      _current = page;
                    });
                    // _selectedSlider.value = page;
                  },
                ),
                items: widget.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(19.0),
                            child: Image.network(
                              "${image ?? image['preview']}",
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                image,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 56.0,
                                left: 8.0,
                                bottom: 10.0,
                                right: 8.0,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 48, 48, 48)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (int i = 0; i < widget.images.length; i++)
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0.75,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: _current == i
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ],
    );
  }
}
