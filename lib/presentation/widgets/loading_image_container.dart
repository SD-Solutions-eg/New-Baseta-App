import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingImageContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final bool repeat;

  const LoadingImageContainer({
    Key? key,
    required this.width,
    required this.height,
    this.repeat = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: authBackgroundColor,
      highlightColor: highlightColor,
      loop: repeat ? 0 : 1,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(verySmallRadius),
          color: authBackgroundColor,
        ),
      ),
    );
  }
}
