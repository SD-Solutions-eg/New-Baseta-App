import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SocialLoginButton extends StatelessWidget {
  final bool isLoading;
  final String socialTitle;
  final String imagePath;
  final String loadingAnimationPath;
  final Widget? loadingWidget;
  final Color color;
  const SocialLoginButton({
    Key? key,
    required this.isLoading,
    required this.socialTitle,
    required this.imagePath,
    required this.loadingAnimationPath,
    required this.color,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.w,
      width: 45.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(verySmallRadius),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 1,
            color: iconGreyColor,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            height: 45.w,
            width: 45.w,
            color: Colors.white,
            child: isLoading
                ? loadingWidget ??
                    SizedBox(
                      height: 35.w,
                      width: 35.w,
                      child: LottieBuilder.asset(
                        loadingAnimationPath,
                      ),
                    )
                : Padding(
                    padding: imagePath.contains('facebook')
                        ? EdgeInsets.all(hVerySmallPadding)
                        : EdgeInsets.zero,
                    child: Image.asset(
                      imagePath,
                      width: 25.w,
                      height: 25.w,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
          // Expanded(
          //   child: Container(
          //     height: 45.w,
          //     color: color,
          //     alignment: Alignment.center,
          //     child: Text(
          //       socialTitle,
          //       style: Theme.of(context)
          //           .textTheme
          //           .subtitle1!
          //           .copyWith(color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
