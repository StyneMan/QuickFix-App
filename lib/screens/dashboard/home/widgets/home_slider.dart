import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickfix_app/helper/state/state_manager.dart';
import 'package:quickfix_app/widgets/shimmer/banner_shimmer.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _current = 0;
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    // print("DATA HERE ::: ${_controller.banners.value}");
    return Obx(
      () => Column(
        children: [
          _controller.banners.value.isEmpty
              ? const BannerShimmer()
              : CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.28,
                    viewportFraction: 1,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 10),
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (int page, _) {
                      setState(() {
                        _current = page;
                      });
                      // _selectedSlider.value = page;
                    },
                  ),
                  items: _controller.banners.value?.map((sliderData) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.28,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              padding: const EdgeInsets.all(14.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(sliderData['preview']),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 4.0,
                              right: 4.0,
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 48.0,
                                  left: 8.0,
                                  bottom: 10.0,
                                  right: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: const SizedBox(
                                  width: 126,
                                  child: Text(
                                    '',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
          const SizedBox(
            height: 4,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     for (int i = 0; i < _controller.banners.length; i++)
          //       Container(
          //         width: _current == i ? 24 : 10,
          //         height: 8,
          //         margin: const EdgeInsets.symmetric(horizontal: 2),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: _current == i
          //               ? Theme.of(context).colorScheme.secondary
          //               : Theme.of(context).colorScheme.inversePrimary,
          //         ),
          //       ),
          //   ],
          // )
        ],
      ),
    );
  }
}
