import 'package:allin1/presentation/screens/aboutUs/about_us_mobile.dart';
import 'package:allin1/presentation/screens/aboutUs/about_us_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtil().screenWidth > 800 ? AboutUsTablet() : AboutUsMobile();
  }
}
