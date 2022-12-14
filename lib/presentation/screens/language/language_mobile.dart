import 'dart:developer';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/languages/languages_cache.dart.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageMobile extends StatefulWidget {
  @override
  _LanguageMobileState createState() => _LanguageMobileState();
}

class _LanguageMobileState extends State<LanguageMobile> {
  bool isAr = false;
  bool isEnglish = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: hLargePadding,
            vertical: vMediumPadding,
          ),
          child: Column(
            children: [
              SizedBox(height: 0.185.sh),
              // Image.asset(
              //   'assets/images/logo.png',
              //   width: 151.w,
              //   height: 94.h,
              //   fit: BoxFit.contain,
              // ),
              SizedBox(height: vVeryLargePadding),
              Text(
                isAr ? 'اهلا بك في $appName' : 'Welcome in $appName',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.black,
                      fontFamily: isAr ? 'Tajawal' : 'Roboto',
                      height: 1,
                    ),
              ),
              SizedBox(height: vSmallPadding),
              Text(
                isAr ? 'اختر لغتك' : 'Choose your language',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.black,
                      fontFamily: isAr ? 'Tajawal' : 'Roboto',
                      height: 1,
                    ),
              ),
              SizedBox(height: vVeryLargePadding),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Material(
                  borderRadius: BorderRadius.circular(largeRadius),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await changeLanguage(context, 'en');

                      setState(() {
                        isEnglish = true;
                        isAr = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().screenWidth > 800
                            ? hLargePadding
                            : hMediumPadding,
                        vertical: vVerySmallMargin,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(largeRadius),
                        color: isEnglish
                            ? Theme.of(context).colorScheme.secondary
                            : disabledButtonColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'English',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color:
                                      isEnglish ? Colors.white : Colors.black,
                                  fontFamily: 'Roboto',
                                ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 30.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: vMediumPadding * 1.1),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Material(
                  borderRadius: BorderRadius.circular(largeRadius),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await changeLanguage(context, 'ar');
                      setState(() {
                        isAr = true;
                        isEnglish = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().screenWidth > 800
                            ? hLargePadding
                            : hMediumPadding,
                        vertical: vVerySmallMargin,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(largeRadius),
                        color: isAr
                            ? Theme.of(context).colorScheme.secondary
                            : disabledButtonColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'عربي',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: isAr ? Colors.white : Colors.black,
                                      fontFamily: 'Tajawal',
                                    ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 30.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: vLargePadding),
              Text(
                !isEnglish
                    ? 'يمكنك تغيير لغتك في اي وقت\nمن الإعدادات '
                    : 'Your language preference can be changed at\nany time in settings',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      height: 2,
                      color: Colors.black,
                      fontFamily: isAr ? 'Tajawal' : 'Roboto',
                    ),
              ),
              SizedBox(height: vVeryLargePadding),
              if (isAr || isEnglish)
                DefaultButton(
                  text: Languages.of(context).start,
                  borderRadius: largeRadius,
                  width: 206.w,
                  height: 50.h,
                  isLoading: isLoading,
                  onPressed: () async {
                    setState(() => isLoading = true);
                    try {
                      await FirebaseMessaging.instance
                          .subscribeToTopic('public');
                      log('Subscribed to public topic');
                      await hydratedStorage.write('notification', true);
                      await hydratedStorage.write(isNewUserTxt, false);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.onBoard,
                        (_) => false,
                      );
                    } catch (e) {
                      setState(() => isLoading = false);
                      customSnackBar(
                          context: context,
                          message: 'Failed to connect to the internet');
                      log(e.toString());
                    }
                  },
                  // child: Text(
                  //   Languages.of(context).start,
                  //   textAlign: TextAlign.center,
                  //   style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  //         fontFamily: isAr ? 'Tajawal' : 'Roboto',
                  //         height: 1,
                  //         color: Colors.white,
                  //       ),
                  // ),
                )
              else
                SizedBox(height: 50.h),
              SizedBox(height: vVeryLargeMargin),
            ],
          ),
        ),
      ),
    );
  }
}
