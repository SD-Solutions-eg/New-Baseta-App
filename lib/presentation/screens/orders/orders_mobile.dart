import 'dart:developer';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/data/models/order_model.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/orders/orders_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;

class OrdersMobile extends StatefulWidget {
  @override
  State<OrdersMobile> createState() => _OrdersMobileState();
}

class _OrdersMobileState extends State<OrdersMobile> {
  late final OrdersCubit ordersCubit;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      ordersCubit = OrdersCubit.get(context);
      if (FirebaseAuthBloc.currentUser != null) {
        ordersCubit.getOrders();
      }
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CategoryCubit.appText!.myOrders),
        titleSpacing: hMediumPadding,
      ),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrdersGetSuccess) {
            setState(() {});
          }
        },
        builder: (context, state) {
          final orders = OrdersCubit.get(context).orders;
          // if (state is! OrdersGetLoading) {
          //
          // } else {
          //   return const LoadingSpinner();
          // }
          if (orders.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().screenWidth > 800
                    ? hLargePadding
                    : hMediumPadding,
                vertical: vSmallPadding,
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  final orderCubit = OrdersCubit.get(context);
                  await orderCubit.getOrders();
                  await orderCubit.refreshOrders();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      orders.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: vMediumPadding,
                        ),
                        child: buildOrderView(
                          context,
                          orders[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return EmptyScreenView(
              icon: IconlyLight.document,
              subtitle: CategoryCubit.appText!.noOrdersSentence,
            );
          }
        },
      ),
    );
  }

  BlocBuilder<OrdersCubit, OrdersState> buildOrderView(
      BuildContext context, OrderModel order) {
    final isAr = Languages.of(context) is LanguageAr;
    final date = intl.DateFormat.yMMMMd(isAr ? 'ar' : 'en')
        .format(DateTime.parse(order.dateCreated));
    final time = intl.DateFormat.jm(isAr ? 'ar' : 'en')
        .format(DateTime.parse(order.dateCreated));
    final role = FirebaseAuthBloc.currentUser!.role;
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouter.orderDetails,
              arguments: order,
            );
            log(order.status.toString());
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).backgroundColor,
              ),
              borderRadius: BorderRadius.circular(smallRadius),
            ),
            child: Column(
              children: [
                SizedBox(height: vSmallPadding),
                buildOrderItem(
                  context,
                  title: CategoryCubit.appText!.order,
                  value: '#${order.orderId}',
                ),
                const Divider(),
                buildOrderItem(
                  context,
                  title: CategoryCubit.appText!.date,
                  value: '$date ,  $time',
                ),
                const Divider(),
                buildOrderItem(
                  context,
                  title: CategoryCubit.appText!.status,
                  valueWidget: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().screenWidth > 800
                          ? hLargePadding
                          : hMediumPadding,
                      vertical: vSmallPadding,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(largeRadius),
                      color: order.status == OrderStatus.delivered
                          ? Colors.green
                          : order.status == OrderStatus.cancelled
                              ? Colors.red
                              : order.status == OrderStatus.onWay
                                  ? Colors.blue
                                  : order.status == OrderStatus.pendingPayment
                                      ? Colors.teal
                                      : Colors.orangeAccent.shade200,
                    ),
                    child: Text(
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
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
                // const Divider(),
                // buildOrderItem(
                //   context,
                //   title: CategoryCubit.appText!.price,
                //   value: '${order.price} ${order.currency}',
                // ),
                // const Divider(),
                // buildOrderItem(
                //   context,
                //   title: CategoryCubit.appText!.shippingFees,
                //   value: '${order.area!.deliveryPrice} ${order.currency}',
                // ),
                // const Divider(),
                // buildOrderItem(
                //   context,
                //   title: CategoryCubit.appText!.total,
                //   value: '$totalCost ${order.currency}',
                // ),
                if (order.delivery != null &&
                    order.status == OrderStatus.onWay &&
                    role == UserType.customer)
                  const Divider(),
                if (order.delivery != null &&
                    order.status == OrderStatus.onWay &&
                    role == UserType.customer)
                  buildOrderItem(
                    context,
                    title: CategoryCubit.appText!.trackOrder,
                    valueWidget: InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.trackOrder,
                        arguments: order,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: hSmallPadding,
                          vertical: vSmallPadding,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(verySmallRadius),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Icon(
                          FontAwesomeIconsLight.location_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                const Divider(),
                buildOrderItem(
                  context,
                  title: CategoryCubit.appText!.action,
                  valueWidget: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.orderDetails,
                        arguments: order,
                      );
                      log(order.status.toString());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: hSmallPadding,
                        vertical: vSmallPadding,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(verySmallRadius),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            FontAwesomeIconsLight.eye,
                            color: Colors.white,
                          ),
                          SizedBox(width: hSmallPadding),
                          Text(
                            CategoryCubit.appText!.view,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container buildOrderItem(
    BuildContext context, {
    required String title,
    String? value,
    Widget? valueWidget,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: vVerySmallPadding),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hSmallPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title:',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            if (value != null)
              Text(
                value,
                style: Theme.of(context).textTheme.bodyText1,
              )
            else if (valueWidget != null)
              valueWidget,
          ],
        ),
      ),
    );
  }
}
