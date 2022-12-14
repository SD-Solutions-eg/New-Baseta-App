import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:flutter/material.dart';

class DefaultButtonTablet extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final bool isLoading;
  final Widget? child;
  final Color? disabledColor;
  final bool smallSize;

  const DefaultButtonTablet({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonColor,
    this.borderRadius,
    this.height,
    this.width,
    this.textColor,
    this.isLoading = false,
    this.child,
    this.disabledColor,
    this.smallSize = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      child: Container(
        width: width ?? 300,
        height: height ?? (smallSize ? 50 : 58),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderRadius != null ? borderRadius! : verySmallRadiusTab,
          ),
        ),
        child: MaterialButton(
          onPressed: isLoading ? null : onPressed,
          color: buttonColor ?? lightPrimary,
          disabledColor: disabledColor ?? lightPrimary,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : child ??
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor ?? lightWhite,
                        fontWeight: FontWeight.normal,
                        fontSize: smallSize
                            ? Theme.of(context).textTheme.subtitle2!.fontSize
                            : Theme.of(context).textTheme.subtitle1!.fontSize,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
