import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              6,
              (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: vSmallPadding),
                child: const ProductLoadingTile(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductLoadingTile extends StatelessWidget {
  const ProductLoadingTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hSmallPadding,
        vertical: vSmallPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: isDark ? darkBgGrey : lightBgGrey,
            highlightColor: isDark ? darkGrey : lightBgGrey2,
            child: Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(width: hMediumPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  height: 18.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: vSmallPadding),
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  height: 10.h,
                  width: 130.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: vMediumPadding),
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  height: 15.h,
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: vSmallPadding),
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
