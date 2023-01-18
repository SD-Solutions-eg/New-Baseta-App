import 'package:allin1/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData getLightTheme({required bool isAr}) {
    final isTab = ScreenUtil().screenWidth >= 800;
    return ThemeData(
      backgroundColor: lightBgGrey2,
      scaffoldBackgroundColor: lightBgWhite,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomAppBarColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: isTab ? 80.w : 70.w,
        titleSpacing: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      canvasColor: lightBgWhite,
      fontFamily: isAr ? 'Alilato' : 'Nexa',
      buttonTheme: ButtonThemeData(
        minWidth: double.infinity,
        height: 60.h,
        buttonColor: lightPrimary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(1)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: lightPrimary),
          textStyle: TextStyle(
            fontSize: isTab ? 12 : 13,
            color: const Color(0xff2F2F2F),
            fontWeight: FontWeight.normal,
          ),
          // padding: EdgeInsets.symmetric(
          //     horizontal: hMediumPadding, vertical: vVerySmallPadding * 0.7.h),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
            lightPrimary,
          ),
        ),
      ),
      textTheme: TextTheme(
        subtitle1: TextStyle(
          fontSize: isTab ? 14.sp : 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        subtitle2: TextStyle(
          fontSize: isTab ? 13.sp : 15.sp,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        bodyText1: TextStyle(
          fontSize: isTab ? 13.sp : 15.sp,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: TextStyle(
          fontSize: isTab ? 11.sp : 13.sp,
          color: const Color(0xff505050),
          fontWeight: FontWeight.normal,
        ),
        headline1: TextStyle(
          fontSize: isTab ? 32.sp : 34.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headline2: TextStyle(
          fontSize: isTab ? 24.sp : 26.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        headline3: TextStyle(
          fontSize: isTab ? 20.sp : 24.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        headline4: TextStyle(
          fontSize: isTab ? 17.sp : 22.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        headline5: TextStyle(
          fontSize: isTab ? 15.sp : 20.sp,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        headline6: TextStyle(
          fontSize: isTab ? 14.sp : 18.sp,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        caption: TextStyle(
          fontSize: isTab ? 11.sp : 13.sp,
          color: captionColor,
        ),
        button: TextStyle(
          fontSize: isTab ? 13.sp : 16.sp,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ).apply(
        fontSizeFactor: 1.1,
      ),
      iconTheme: const IconThemeData().copyWith(size: 16),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: lightAccentAllin1,
      ),
      sliderTheme: SliderThemeData(
          activeTickMarkColor: authBackgroundColor,
          activeTrackColor: authBackgroundColor,
          disabledActiveTickMarkColor: authBackgroundColor,
          disabledActiveTrackColor: authBackgroundColor,
          inactiveTickMarkColor: authBackgroundColor,
          inactiveTrackColor: authBackgroundColor,
          valueIndicatorColor: Colors.transparent,
          valueIndicatorTextStyle:
              const TextStyle(fontSize: 10, color: Colors.black, height: 0.5),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          overlayColor: lightPrimary.withOpacity(0.2),
          rangeThumbShape: const RoundRangeSliderThumbShape(
            enabledThumbRadius: 14,
            elevation: 4,
            pressedElevation: 10,
          )),
    );
  }

  static void setStatusBarAndNotificationBarColor(ThemeMode themeMode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness:
          themeMode == ThemeMode.light ? Brightness.light : Brightness.dark,
      statusBarIconBrightness:
          themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness:
          themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }

  static Brightness? get currentSystemBrightness {
    return SchedulerBinding.instance.window.platformBrightness;
  }
}
