// ignore_for_file: unused_element

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/on_boarding_data.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

int _previousIndex = 0;

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final Duration animatedSplashDuration = const Duration(milliseconds: 500);
  bool isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Languages.of(context) is LanguageAr;

    final onBoardingData =
        isArabic ? OnBoardingData.data : OnBoardingData.dataEn;
    final languages = Languages.of(context);

    return Scaffold(
      backgroundColor: const Color(0xff99BA45),
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) {
              if (mounted) {
                setState(() => _selectedIndex = index);
              }
            },
            controller: _pageController,
            itemCount: OnBoardingData.data.length,
            itemBuilder: (context, index) {
              return Stack(
                // alignment: ,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                onBoardingData[index]['image'] as String))),
                  ),
                  OnBoardingContentView(index: index),
                ],
              );
            },
          ),
          Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    OnBoardingData.data.length,
                    (index) => buildAnimatedDot(index),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hMediumPadding,
                  vertical: vSmallMargin,
                ),
                child: DefaultButton(
                  width: double.infinity,
                  text: languages.start,
                  buttonColor: Colors.white,
                  textColor: primarySwatch,
                  isLoading: isLoading,
                  onPressed: () async {
                    setState(() => isLoading = true);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.splash,
                      (_) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildAnimatedDot(int index) {
    return AnimatedContainer(
      duration: animatedSplashDuration,
      curve: Curves.ease,
      width: index == _selectedIndex ? 13 : 8,
      height: index == _selectedIndex ? 13 : 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == _selectedIndex ? Colors.white : Colors.white54,
      ),
    );
  }
}

class OnBoardingContentView extends StatelessWidget {
  final int index;

  const OnBoardingContentView({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = Languages.of(context) is LanguageAr;
    final onBoardingData =
        isArabic ? OnBoardingData.data : OnBoardingData.dataEn;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 0.2.sh,
        ),
        Center(
          child: Text(
            onBoardingData[index]['title'] as String,
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        // SvgPicture.asset(
        //   onBoardingData[index]['image'] as String,
        //   width: 120.w,
        //   height: 240.h,
        // ),
        // SizedBox(height: vSmallMargin),
        // Text(
        //   onBoardingData[index]['title'] as String,
        //   style: Theme.of(context)
        //       .textTheme
        //       .headline5!
        //       .copyWith(color: primarySwatch),
        // ),
        Builder(
          builder: (context) {
            _previousIndex = index;
            return const Offstage();
          },
        ),
      ],
    );
  }
}
