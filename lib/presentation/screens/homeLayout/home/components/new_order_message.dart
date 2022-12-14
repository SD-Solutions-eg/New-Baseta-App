import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iconly/iconly.dart';

class NewOrderMessage extends StatelessWidget {
  final OrderModel order;
  const NewOrderMessage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRouter.orderDetails,
        arguments: order,
      ),
      borderRadius: BorderRadius.circular(verySmallRadius),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: hVerySmallMargin, vertical: vSmallPadding),
        margin: EdgeInsets.symmetric(
                horizontal: hMediumPadding, vertical: vSmallPadding)
            .copyWith(bottom: vVerySmallPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(verySmallRadius),
          color: Theme.of(context).colorScheme.primary,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  IconlyBold.activity,
                  size: 20.w,
                  color: Colors.white,
                ),
                SizedBox(width: hSmallPadding),
                Text(
                  '${CategoryCubit.appText!.newOrder} #${order.orderId}',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                AnimatedTextKit(
                  totalRepeatCount: 2,
                  onTap: order.status == OrderStatus.waiting &&
                          order.delivery != null
                      ? () => Navigator.pushNamed(context, AppRouter.trackOrder,
                          arguments: order)
                      : null,
                  animatedTexts: [
                    TyperAnimatedText(
                      // order.status.name,
                      order.status == OrderStatus.waiting
                          ? Languages.of(context).waiting
                          : order.status == OrderStatus.delivered
                              ? Languages.of(context).delivered
                              : order.status == OrderStatus.cancelled
                                  ? CategoryCubit.appText!.cancelled
                                  : order.status == OrderStatus.onWay
                                      ? Languages.of(context).onWay
                                      : order.status ==
                                              OrderStatus.pendingPayment
                                          ? Languages.of(context).pendingPayment
                                          : order.status ==
                                                  OrderStatus.assigningDelivery
                                              ? Languages.of(context)
                                                  .assigningDelivery
                                              : CategoryCubit
                                                  .appText!.pendingReview,
                      textStyle:
                          Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                      speed: const Duration(milliseconds: 150),
                    ),
                  ],
                ),
                if (order.status == OrderStatus.onWay && order.delivery != null)
                  InkWell(
                    onTap: () => Navigator.pushNamed(
                        context, AppRouter.trackOrder,
                        arguments: order),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.only(start: hVerySmallPadding),
                      child: Icon(
                        FontAwesomeIconsLight.location_circle,
                        size: 22.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
