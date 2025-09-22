import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeroBannerWidget extends StatefulWidget {
  const HeroBannerWidget({super.key});

  @override
  State<HeroBannerWidget> createState() => _HeroBannerWidgetState();
}

class _HeroBannerWidgetState extends State<HeroBannerWidget> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<Map<String, dynamic>> _bannerData = [
    {
      "id": 1,
      "title": "Free Drone Delivery",
      "subtitle": "On orders above \$25",
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800",
      "backgroundColor": AppTheme.accentYellow,
      "textColor": AppTheme.primaryBlack,
    },
    {
      "id": 2,
      "title": "Lightning Fast",
      "subtitle": "15-minute drone delivery",
      "image":
          "https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=800&q=80",
      "backgroundColor": AppTheme.primaryBlack,
      "textColor": AppTheme.surfaceWhite,
    },
    {
      "id": 3,
      "title": "New Restaurant Alert",
      "subtitle": "Discover amazing cuisines",
      "image":
          "https://images.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg",
      "backgroundColor": AppTheme.successGreen,
      "textColor": AppTheme.surfaceWhite,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 20.h,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: _bannerData.map((banner) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.w),
                      color: banner["backgroundColor"] as Color,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowSubtle,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.w),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width: 40.w,
                            child: CustomImageWidget(
                              imageUrl: banner["image"] as String,
                              width: 40.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 4.w,
                            top: 4.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner["title"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    color: banner["textColor"] as Color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  banner["subtitle"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: (banner["textColor"] as Color)
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/search-screen');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        banner["textColor"] as Color,
                                    foregroundColor:
                                        banner["backgroundColor"] as Color,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 1.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                    ),
                                  ),
                                  child: Text(
                                    'Order Now',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _bannerData.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: _currentIndex == entry.key ? 8.w : 2.w,
                  height: 1.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.w),
                    color: _currentIndex == entry.key
                        ? AppTheme.accentYellow
                        : AppTheme.neutralGray,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
