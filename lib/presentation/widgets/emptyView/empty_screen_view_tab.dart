import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class EmptyScreenViewTablet extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onTap;
  final bool shiftLeft;

  const EmptyScreenViewTablet({
    Key? key,
    this.icon,
    this.title,
    this.subtitle,
    this.buttonText,
    this.onTap,
    this.shiftLeft = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: vVeryLargeMarginTab * 2.4),

          Directionality(
            textDirection: TextDirection.ltr,
            child: DottedBorder(
              borderType: BorderType.Circle,
              padding: const EdgeInsets.symmetric(
                horizontal: hLargeMarginTab,
                vertical: hLargeMarginTab,
              ).copyWith(
                left: shiftLeft ? hLargeMarginTab * 0.7 : hLargeMarginTab,
                right: shiftLeft ? hLargeMarginTab : hLargeMarginTab,
              ),
              color: iconGreyColor,
              strokeWidth: 2,
              dashPattern: const [
                4,
                4,
              ],
              child: Center(
                child: Icon(
                  icon ?? Icons.menu,
                  size: 70,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          // SizedBox(height: vSmallPadding),
          // Text(
          //   title ?? '',
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline3!
          //       .copyWith(fontWeight: FontWeight.w500),
          // ),
          const SizedBox(height: vLargePaddingTab),
          Text(
            subtitle ?? CategoryCubit.appText!.empty,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: isDark ? darkTextColor : lightTextColor),
          ),
          // if (buttonText != null) ...[
          //   SizedBox(height: vMediumPadding),
          //   DefaultButton(
          //     text: buttonText!,
          //     width: 200,
          //     height: 55,
          //     onPressed: onTap,
          //   ),
          //   SizedBox(height: vVeryLargeMarginTab),
          // ],
        ],
      ),
    );
  }
}
