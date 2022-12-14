import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyScreenView extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onTap;
  final bool shiftLeft;

  const EmptyScreenView({
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
          SizedBox(height: vVeryLargeMargin * 2.4),
          Directionality(
            textDirection: TextDirection.ltr,
            child: DottedBorder(
              borderType: BorderType.Circle,
              padding: EdgeInsets.symmetric(
                horizontal: hLargeMargin,
                vertical: hLargeMargin,
              ).copyWith(
                left: shiftLeft ? hLargeMargin * 0.7 : hLargeMargin,
                right: shiftLeft ? hLargeMargin : hLargeMargin,
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
                  size: 70.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          if (title != null) SizedBox(height: vSmallPadding),
          if (title != null)
            Text(
              title!,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          SizedBox(height: vLargePadding),
          Text(
            subtitle ?? CategoryCubit.appText!.empty,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: isDark ? darkTextColor : lightTextColor),
          ),
          if (buttonText != null) ...[
            SizedBox(height: vMediumPadding),
            DefaultButton(
              text: buttonText!,
              width: 120.w,
              height: 40.w,
              onPressed: onTap,
            ),
            SizedBox(height: vVeryLargeMargin),
          ],
        ],
      ),
    );
  }
}
