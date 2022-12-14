// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/cart_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/notificationCount/notification_count.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart' as intl;

class UnderlineContainer extends StatelessWidget {
  const UnderlineContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class MyDottedLine extends StatelessWidget {
  const MyDottedLine({
    Key? key,
    this.color,
  }) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      dashColor: color ?? Theme.of(context).colorScheme.primary,
      dashLength: 2,
      dashGapLength: 2,
    );
  }
}

class AnimatedBullet extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final bool isLastIndex;
  const AnimatedBullet({
    Key? key,
    required this.index,
    required this.selectedIndex,
    required this.isLastIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.ease,
      width: index == selectedIndex ? 20.w : 9.w,
      height: 9.w,
      margin: EdgeInsetsDirectional.only(
        start: index == selectedIndex ? 9.w : 3.w,
        end: index == selectedIndex && !isLastIndex ? 6.w : 0,
      ),
      decoration: BoxDecoration(
        color: index == selectedIndex
            ? primarySwatch
            : iconGreyColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(smallRadius),
      ),
    );
  }
}

class PricesWidget extends StatelessWidget {
  const PricesWidget({
    Key? key,
    required this.regularPrice,
    this.salePrice,
    this.smallSize = true,
    this.currency,
    this.axis = DismissDirection.horizontal,
  }) : super(key: key);
  final String regularPrice;
  final String? salePrice;
  final bool smallSize;
  final String? currency;
  final DismissDirection axis;

  @override
  Widget build(BuildContext context) {
    final String? salePrice =
        this.salePrice == '0' || this.salePrice == '' ? null : this.salePrice;
    final regularPriceDouble = double.tryParse(regularPrice);
    final price = regularPriceDouble != null
        ? intl.NumberFormat.decimalPattern().format(regularPriceDouble)
        : regularPrice;
    final currencySym = CategoryCubit.currency!;
    return axis == DismissDirection.horizontal
        ? Row(
            children: [
              if (salePrice != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$currencySym ',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontSize: smallSize ? 10.sp : 12.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Text(
                      intl.NumberFormat.decimalPattern()
                          .format(num.parse(salePrice)),
                      style: smallSize
                          ? Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontFamily: 'Roboto',
                              )
                          : Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontFamily: 'Roboto',
                              ),
                    ),
                  ],
                ),
                SizedBox(width: hSmallPadding),
                RichText(
                  text: TextSpan(
                    text: '$currencySym ',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: previousPriceColor.withOpacity(0.6),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: previousPriceColor,
                          fontWeight: FontWeight.normal,
                          fontSize: smallSize ? 10.sp : 12.sp,
                          fontFamily: 'Roboto',
                        ),
                    children: [
                      TextSpan(
                        text: intl.NumberFormat.decimalPattern()
                            .format(num.parse(regularPrice)),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: previousPriceColor.withOpacity(0.8),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: previousPriceColor,
                              fontWeight: FontWeight.normal,
                              fontSize: smallSize ? 12.sp : 14.sp,
                              fontFamily: 'Roboto',
                            ),
                      ),
                    ],
                  ),
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$currencySym ',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontSize: smallSize ? 10.sp : 12.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Text(
                      price,
                      style: smallSize
                          ? Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontFamily: 'Roboto',
                              )
                          : Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontFamily: 'Roboto',
                              ),
                    ),
                  ],
                ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (salePrice != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$currencySym ',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Text(
                      intl.NumberFormat.decimalPattern()
                          .format(num.parse(salePrice)),
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontFamily: 'Roboto',
                          ),
                    ),
                  ],
                ),
                SizedBox(width: hSmallPadding),
                RichText(
                  text: TextSpan(
                    text: '$currencySym ',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: previousPriceColor.withOpacity(0.6),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: previousPriceColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',
                        ),
                    children: [
                      TextSpan(
                        text: intl.NumberFormat.decimalPattern()
                            .format(num.parse(regularPrice)),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: previousPriceColor.withOpacity(0.8),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: previousPriceColor,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                      ),
                    ],
                  ),
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$currencySym ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      price,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontFamily: 'Roboto',
                          ),
                    ),
                  ],
                ),
            ],
          );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton(
    this.context, {
    Key? key,
  }) : super(key: key);
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark
              ? Colors.white24
              : const Color(0xff4B4B4B).withOpacity(0.25),
        ),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: () {
          Scaffold.of(context).openDrawer();
          final hasDrawer = Scaffold.hasDrawer(context);
          log('Has Drawer: $hasDrawer');
          // setState(() => _showFilter = !_showFilter);
        },
        child: Icon(
          ETagerIcons.sort_amount_down,
          size: 22.w,
          color: const Color(0xff4B4B4B),
        ),
      ),
    );
  }
}

class CartButtonWithCount extends StatelessWidget {
  const CartButtonWithCount({
    Key? key,
    required this.cartModel,
  }) : super(key: key);

  final CartModel? cartModel;

  @override
  Widget build(BuildContext context) {
    final language = Languages.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(largeRadius),
      child: InkWell(
        onTap: () {
          Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
          tabController?.animateTo(3);
        },
        borderRadius: BorderRadius.circular(largeRadius),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              hSmallPadding, hSmallPadding, hSmallPadding, hSmallPadding),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                ETagerIcons.cart_arrow_down,
                size: 22.w,
              ),
              if (cartModel != null && cartModel!.itemsCount > 0)
                Positioned.directional(
                  textDirection: language is LanguageAr
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  top: -vSmallPadding * 1.3,
                  end: -hSmallPadding * 1.6,
                  child: OvalNotifyCount(count: cartModel!.itemsCount),
                )
              else
                const Offstage(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductLabelItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onSelected;
  final bool inDrawer;
  const ProductLabelItem({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.inDrawer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hVerySmallPadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(largeRadius),
        onTap: onSelected,
        child: Container(
          width: 35.0.w + 7.w * label.length,
          height: inDrawer ? null : 30.w,
          alignment: Alignment.center,
          padding: inDrawer
              ? EdgeInsets.symmetric(
                  vertical: vSmallPadding * 0.8,
                )
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.black : iconGreyColor.withOpacity(0.6),
            ),
            borderRadius: inDrawer
                ? BorderRadius.circular(verySmallRadius)
                : BorderRadius.circular(largeRadius),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: isSelected ? Colors.black : iconGreyColor,
                    fontFamily: 'Roboto',
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineBorderContainer extends StatelessWidget {
  const OutlineBorderContainer({
    Key? key,
    required this.child,
    this.onTap,
    required this.radiusStart,
    required this.radiusEnd,
    this.width,
    this.height,
    this.radius = 20,
    this.outlineOnly = false,
    this.color,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final bool radiusStart;
  final bool radiusEnd;
  final double? width;
  final double? height;
  final double radius;
  final bool outlineOnly;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 37.h,
      width: width ?? (!radiusStart && !radiusEnd ? 50.w : 40.w),
      decoration: BoxDecoration(
        border: outlineOnly
            ? null
            : !radiusStart && !radiusEnd
                ? const Border.symmetric(
                    horizontal: BorderSide(color: iconGreyColor),
                    vertical: BorderSide(color: Colors.transparent),
                  )
                : Border.all(color: iconGreyColor),
        borderRadius: !radiusStart && !radiusEnd
            ? null
            : BorderRadiusDirectional.horizontal(
                start: radiusStart ? Radius.circular(radius) : Radius.zero,
                end: radiusEnd ? Radius.circular(radius) : Radius.zero,
              ),
        color: color,
      ),
      child: InkWell(onTap: onTap, child: Center(child: child)),
    );
  }
}
