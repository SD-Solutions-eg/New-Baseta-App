import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingTablet extends StatelessWidget {
  const ShimmerLoadingTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              6,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: vSmallPaddingTab),
                child: ProductLoadingTileTablet(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductLoadingTileTablet extends StatelessWidget {
  const ProductLoadingTileTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hSmallPadding,
        vertical: vSmallPaddingTab,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: isDark ? darkBgGrey : lightBgGrey,
            highlightColor: isDark ? darkGrey : lightBgGrey2,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(width: hMediumPaddingTab),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  height: 18,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: vSmallPaddingTab),
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  height: 10,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: vMediumPaddingTab),
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  height: 15,
                  width: 180,
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
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: vSmallPaddingTab),
              Shimmer.fromColors(
                baseColor: isDark ? darkBgGrey : lightBgGrey,
                highlightColor: isDark ? darkGrey : lightBgGrey2,
                child: Container(
                  width: 30,
                  height: 30,
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
