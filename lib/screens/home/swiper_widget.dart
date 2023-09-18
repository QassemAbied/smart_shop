import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class SwiperWidget extends StatefulWidget {
  const SwiperWidget({super.key});

  @override
  State<SwiperWidget> createState() => _SwiperWidgetState();
}

class _SwiperWidgetState extends State<SwiperWidget> {
  List<String> images = [
    'assets/images/banners/banner1.png',
    'assets/images/banners/banner2.png',
  ];
  @override
  Widget build(BuildContext context) {

    return Swiper(
      allowImplicitScrolling: true,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return Image.asset(
          images[index],
          fit: BoxFit.fill,
        );
      },
      itemCount: 2,
      pagination: const SwiperPagination(
        alignment: Alignment.bottomCenter,
        builder: DotSwiperPaginationBuilder(
          color: Colors.tealAccent,
          activeColor: Colors.teal,
        ),
      ),
      // control: SwiperControl(
      //   color: Colors.black
      // ),
    );
  }
}
