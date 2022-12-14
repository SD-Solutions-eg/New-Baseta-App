import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileItemContainer extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final Color? textColor;
  final bool showIcon;
  final Widget? child;
  const ProfileItemContainer({
    Key? key,
    this.text,
    this.onTap,
    this.textColor,
    this.showIcon = true,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 55.h,
      padding: EdgeInsets.symmetric(
          horizontal: hSmallPadding, vertical: vSmallPadding),
      decoration: BoxDecoration(
          color: isDark ? darkBgGrey : lightBgGrey,
          borderRadius: BorderRadius.circular(smallRadius)),
      child: InkWell(
        onTap: onTap,
        child: child ??
            Row(
              children: [
                Text(
                  text!,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: textColor,
                      ),
                ),
                const Spacer(),
                if (showIcon)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12.w,
                  ),
              ],
            ),
      ),
    );
  }
}
