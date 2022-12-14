// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/cart_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/e_tager_icons_icons.dart';
import 'package:allin1/presentation/widgets/notificationCount/notification_count_tab.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart' as intl;

class UnderlineContainerTablet extends StatelessWidget {
  const UnderlineContainerTablet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class MyDottedLineTablet extends StatelessWidget {
  const MyDottedLineTablet({
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

class PricesWidgetTablet extends StatelessWidget {
  const PricesWidgetTablet({
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
                const SizedBox(width: hSmallPaddingTab),
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
                const SizedBox(width: hSmallPaddingTab),
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

class FilterButtonTab extends StatelessWidget {
  const FilterButtonTab(
    this.context, {
    Key? key,
  }) : super(key: key);
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
        ),
        borderRadius: BorderRadius.circular(8),
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
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class CartButtonWithCountTablet extends StatelessWidget {
  const CartButtonWithCountTablet({
    Key? key,
    required this.cartModel,
  }) : super(key: key);

  final CartModel? cartModel;

  @override
  Widget build(BuildContext context) {
    final language = Languages.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(largeRadiusTab),
      child: InkWell(
        onTap: () {
          Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
          tabController?.animateTo(2);
        },
        borderRadius: BorderRadius.circular(largeRadiusTab),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(hSmallPaddingTab,
              hSmallPaddingTab, hSmallPaddingTab, hSmallPaddingTab),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                ETagerIcons.cart_arrow_down,
                size: 28,
              ),
              if (cartModel != null && cartModel!.itemsCount > 0)
                Positioned.directional(
                  textDirection: language is LanguageAr
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  top: -vSmallPaddingTab * 1.3,
                  end: -hSmallPaddingTab * 1.6,
                  child: OvalNotifyCountTablet(count: cartModel!.itemsCount),
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
