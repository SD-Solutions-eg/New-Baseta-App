// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/payment/payment_mobile.dart';
import 'package:allin1/presentation/widgets/MainTabView/main_tab_view.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:allin1/presentation/widgets/formBuilderField/form_builder_field.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:allin1/presentation/widgets/text_headlines.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetailsScreen({Key? key, required this.orderModel})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TextEditingController? priceController = TextEditingController();
  late OrderModel orderModel;
  late final OrdersCubit ordersCubit;
  double rating = 0;
  bool acceptLoading = false;
  bool acceptable = true;
  List<OrderStatus> ordersStatus = [];
  bool cancelLoading = false;
  TextEditingController commentController = TextEditingController();
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      orderModel = widget.orderModel;
      ordersCubit = OrdersCubit.get(context);
      setState(() {});
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final role = FirebaseAuthBloc.currentUser!.role;
    return Scaffold(
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (role == UserType.customer) {
            orderModel = OrdersCubit.get(context)
                .newCustomerProcessingOrders
                .firstWhere(
                    (order) => order.orderId == widget.orderModel.orderId,
                    orElse: () => widget.orderModel);
          } else if (role == UserType.delivery) {
            orderModel = OrdersCubit.get(context)
                .newDeliveryAssignedOrders
                .firstWhere(
                    (order) => order.orderId == widget.orderModel.orderId,
                    orElse: () => widget.orderModel);
          }
          // if (state is! OrdersGetLoading) {
          //   return MainTabView(
          //     leading: true,
          //     title: CategoryCubit.appText!.orderDetails,
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: ScreenUtil().screenWidth > 800
          //             ? hLargePadding
          //             : hMediumPadding,
          //         vertical: vMediumPadding,
          //       ),
          //       child: SingleChildScrollView(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             buildOrderNoteView(context),
          //             SizedBox(height: vMediumPadding),
          //             buildOrderView(context, orderModel),
          //             SizedBox(height: vMediumPadding),
          //             MainHeadline(title: CategoryCubit.appText!.orderDetails),
          //             SizedBox(height: vMediumPadding),
          //             buildOrderDetails(isDark: isDark, context: context),
          //             if (orderModel.status != OrderStatus.delivered &&
          //                 orderModel.status != OrderStatus.cancelled) ...[
          //               Divider(height: vLargePadding),
          //               MainHeadline(title: CategoryCubit.appText!.action)
          //             ],
          //             SizedBox(height: vMediumPadding * 2),
          //             if (role == UserType.delivery)
          //               DeliveryActions(
          //                   orderModel: orderModel,
          //                   priceController: priceController),
          //             if (role == UserType.customer)
          //               CustomerActions(orderModel: orderModel),
          //             SizedBox(height: vVeryLargePadding),
          //           ],
          //         ),
          //       ),
          //     ),
          //   );
          // }
          // return const Center(child: CircularProgressIndicator());
          return MainTabView(
            leading: true,
            title: CategoryCubit.appText!.orderDetails,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().screenWidth > 800
                    ? hLargePadding
                    : hMediumPadding,
                vertical: vMediumPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildOrderNoteView(context),
                    SizedBox(height: vMediumPadding),
                    buildOrderView(context, orderModel),
                    SizedBox(height: vMediumPadding),
                    MainHeadline(title: CategoryCubit.appText!.orderDetails),
                    SizedBox(height: vMediumPadding),
                    buildOrderDetails(isDark: isDark, context: context),
                    if (orderModel.status != OrderStatus.delivered &&
                        orderModel.status != OrderStatus.cancelled) ...[
                      Divider(height: vLargePadding),
                      MainHeadline(title: CategoryCubit.appText!.action)
                    ],
                    SizedBox(height: vMediumPadding * 2),
                    if (role == UserType.delivery) ...[
                      if (orderModel.delivery != null &&
                          orderModel.status ==
                              OrderStatus.assigningDelivery) ...[
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: vLargePadding),
                          child: BlocConsumer<OrdersCubit, OrdersState>(
                            listener: (context, state) {
                              if (state is ChangeOrderStatusSuccess) {
                                ordersCubit.refreshOrders();
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, state) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          acceptLoading = true;
                                          cancelLoading = false;
                                        });
                                        setState(() {
                                          ordersStatus.clear();
                                          for (final element in ordersCubit
                                              .newDeliveryAssignedOrders) {
                                            if (element.orderId !=
                                                orderModel.orderId) {
                                              setState(() {
                                                // acceptable = false;
                                                // acceptLoading = false;
                                                // log('acceptable? : $acceptable');
                                                ordersStatus
                                                    .add(element.status);
                                              });
                                            }
                                          }
                                        });
                                        log('ordersStatus : $ordersStatus');
                                        if (ordersStatus.contains(
                                                OrderStatus.waiting) ||
                                            ordersStatus.contains(
                                                OrderStatus.pendingPayment) ||
                                            ordersStatus
                                                .contains(OrderStatus.onWay)) {
                                          setState(() {
                                            acceptable = false;
                                            acceptLoading = false;
                                            log('acceptable? : $acceptable');
                                          });
                                        } else {
                                          setState(() {
                                            acceptable = true;
                                            log('acceptable? : $acceptable');
                                          });
                                        }
                                        // for(int i = 0 ; i<ordersCubit.newDeliveryAssignedOrders.length
                                        //     &&ordersCubit.newDeliveryAssignedOrders[i].orderId != order.orderId; i++){
                                        //   if(ordersCubit.newDeliveryAssignedOrders[i].status != OrderStatus.delivered
                                        //   ){
                                        //     setState(() {
                                        //       acceptable = false;
                                        //       acceptLoading = true;
                                        //     });
                                        //   }
                                        // }
                                        acceptable
                                            ? await ordersCubit
                                                .updateOrderStatus(
                                                    status: 'waiting',
                                                    orderModel: orderModel)
                                            : customSnackBar(
                                                context: context,
                                                message: CategoryCubit
                                                    .appText!.cannotAccept);
                                      },
                                      child: Container(
                                        height: 55.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              verySmallRadius),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        alignment: Alignment.center,
                                        child: state
                                                    is ChangeOrderStatusLoading &&
                                                acceptLoading
                                            ? SizedBox(
                                                width: 15.w,
                                                height: 15.w,
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.white,
                                                )))
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    FontAwesomeIconsLight
                                                        .check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                      width: hSmallPadding),
                                                  Text(
                                                    CategoryCubit
                                                        .appText!.accept,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: hVerySmallPadding,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          cancelLoading = true;
                                          acceptLoading = false;
                                        });
                                        await ordersCubit.updateOrderStatus(
                                            status: 'delivery_cancelled',
                                            orderModel: orderModel,
                                            userId: FirebaseAuthBloc
                                                .currentUser!.id
                                                .toString());
                                      },
                                      child: Container(
                                        height: 55.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              verySmallRadius),
                                          color: Colors.red,
                                        ),
                                        alignment: Alignment.center,
                                        child: state
                                                    is ChangeOrderStatusLoading &&
                                                cancelLoading
                                            ? SizedBox(
                                                width: 15.w,
                                                height: 15.w,
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.white,
                                                )))
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    CupertinoIcons
                                                        .clear_circled,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                      width: hSmallPadding),
                                                  Text(
                                                    CategoryCubit
                                                        .appText!.cancel,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                      DeliveryActions(
                          orderModel: orderModel,
                          priceController: priceController),
                    ],
                    if (role == UserType.customer)
                      BlocBuilder<OrdersCubit, OrdersState>(
                        builder: (context, state) {
                          return CustomerActions(orderModel: orderModel);
                        },
                      ),
                    if (orderModel.status == OrderStatus.delivered)
                      orderModel.review == null
                          ? BlocConsumer<OrdersCubit, OrdersState>(
                              listener: (context, state) {
                                final OrdersCubit ordersCubit =
                                    OrdersCubit.get(context);
                                if (state is ReviewOrderSuccess) {
                                  ordersCubit.refreshOrders();
                                  ordersCubit.getOrders();
                                  Navigator.pop(context);
                                  // customSnackBar(
                                  //     context: context,
                                  //     message: 'Success',
                                  //     color: primarySwatch);
                                } else if (state is ReviewOrderFailed) {
                                  customSnackBar(
                                      context: context, message: state.error);
                                }
                              },
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        MainHeadline(
                                            title: Languages.of(context)
                                                .rateDelivery),
                                        SizedBox(width: hLargePadding),
                                        RatingBar.builder(
                                          initialRating: rating,
                                          minRating: 1,
                                          glowColor: const Color(0xffF3E184),
                                          unratedColor: const Color(0xffCFD8DC),
                                          itemSize: 33.w,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1, vertical: 5),
                                          onRatingUpdate: (value) {
                                            rating = value;
                                            setState(() {});
                                          },
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star_rate_rounded,
                                            color: Color(0xffFECE00),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: vMediumPadding),
                                    MyFormBuilderFiled(
                                      id: 'content',
                                      maxLines: 5,
                                      controller: commentController,
                                      titlePrefix: Icon(
                                        IconlyBold.document,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 22.w,
                                      ),
                                      hintText:
                                          CategoryCubit.appText!.addReview,
                                      fillColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return CategoryCubit
                                              .appText!.filedIsRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: vMediumPadding),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        DefaultButton(
                                          width: 90.w,
                                          height: 40.h,
                                          text: CategoryCubit.appText!.confirm,
                                          isLoading:
                                              state is ReviewOrderLoading,
                                          onPressed: () {
                                            if (rating == 0) {
                                              customSnackBar(
                                                  context: context,
                                                  message: 'يرجي اضافة تقييم');
                                              return;
                                            } else {
                                              final OrdersCubit ordersCubit =
                                                  OrdersCubit.get(context);
                                              ordersCubit.reviewOrderDelivery(
                                                  orderModel: orderModel,
                                                  comment:
                                                      commentController.text,
                                                  rating: rating.toString());
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    MainHeadline(
                                        title:
                                            Languages.of(context).rateDelivery),
                                    SizedBox(width: hLargePadding),
                                    RatingBar.builder(
                                      initialRating: double.parse(
                                          orderModel.review!.rating),
                                      minRating: 1,
                                      ignoreGestures: true,
                                      glowColor: const Color(0xffF3E184),
                                      unratedColor: const Color(0xffCFD8DC),
                                      itemSize: 33.w,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 5),
                                      onRatingUpdate: (value) {},
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star_rate_rounded,
                                        color: Color(0xffFECE00),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: vMediumPadding),
                                if (orderModel.review!.comment != '')
                                  MyFormBuilderFiled(
                                    id: 'comment',
                                    maxLines: 5,
                                    initialValue: orderModel.review!.comment,
                                    readOnly: true,
                                    // controller: commentController,
                                    titlePrefix: Icon(
                                      IconlyBold.document,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 22.w,
                                    ),
                                    fillColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return CategoryCubit
                                            .appText!.filedIsRequired;
                                      }
                                      return null;
                                    },
                                  )
                                else
                                  const SizedBox(),
                                SizedBox(height: vMediumPadding),
                              ],
                            ),
                    SizedBox(height: vVeryLargePadding),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container buildAddressContainer(BuildContext context,
      {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: hSmallPadding,
        vertical: vSmallPadding,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).backgroundColor,
        ),
        borderRadius: BorderRadius.circular(smallRadius),
      ),
      child: child,
    );
  }

  Widget buildOrderDetails(
      {required bool isDark, required BuildContext context}) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
              horizontal: hMediumPadding, vertical: vMediumPadding),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).backgroundColor,
            ),
            borderRadius: BorderRadius.circular(smallRadius),
          ),
          child: Text(
            orderModel.orderContent,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        SizedBox(height: vSmallPadding),
        if (orderModel.image != null)
          GestureDetector(
            onTap: () {
              final imageProvider =
                  Image.network(orderModel.image.toString()).image;
              showImageViewer(context, imageProvider, onViewerDismissed: () {
                print("dismissed");
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 250.h,
              padding: EdgeInsets.symmetric(
                  horizontal: hMediumPadding, vertical: vMediumPadding),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).backgroundColor,
                ),
                borderRadius: BorderRadius.circular(smallRadius),
              ),
              child: ColoredBox(
                color: Theme.of(context).backgroundColor,
                child: Image.network(orderModel.image.toString()),
              ),
            ),
          )
      ],
    );
  }

  Container buildOrderView(BuildContext context, OrderModel order) {
    final isAr = Languages.of(context) is LanguageAr;
    final date = intl.DateFormat.yMMMMd(isAr ? 'ar' : 'en')
        .format(DateTime.parse(order.dateCreated));
    final time = intl.DateFormat.jm(isAr ? 'ar' : 'en')
        .format(DateTime.parse(order.dateCreated));
    double totalCost;
    try {
      log('serviceFee: ${order.serviceFee}');
      totalCost = double.parse(order.price == '' ? '0' : order.price) +
          double.parse(order.serviceFee == '' ? '0' : order.serviceFee) +
          double.parse(order.area!.deliveryPrice) -
          double.parse(order.discount);
    } catch (e) {
      totalCost = 0;
      log(e.toString());
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).backgroundColor,
        ),
        borderRadius: BorderRadius.circular(smallRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          buildOrderItem(
            context,
            title: CategoryCubit.appText!.order,
            value: '#${order.orderId}',
            color: Theme.of(context).colorScheme.primary,
            textColor: Colors.white,
          ),
          SizedBox(height: vSmallPadding),
          buildOrderItem(
            context,
            title: CategoryCubit.appText!.date,
            value: '$date ,  $time',
          ),
          const Divider(),
          buildOrderItem(
            context,
            title: CategoryCubit.appText!.price,
            value: '${order.price} ${order.currency}',
          ),
          const Divider(),
          buildOrderItem(
            context,
            title: CategoryCubit.appText!.shippingFees,
            value: '+ ${order.area!.deliveryPrice} ${order.currency}',
          ),
          const Divider(),
          buildOrderItem(
            context,
            title: Languages.of(context).serviceFee,
            value:
                '+ ${order.serviceFee == '' ? 0 : order.serviceFee} ${order.currency}',
          ),
          if (double.parse(order.discount) > 0) ...[
            const Divider(),
            buildOrderItem(
              context,
              title: CategoryCubit.appText!.couponDiscount,
              value:
                  '- ${double.parse(order.discount).toStringAsFixed(2)} ${order.currency}',
            ),
          ],
          const Divider(),
          buildOrderItem(
            context,
            title: CategoryCubit.appText!.total,
            value: '$totalCost ${order.currency}',
          ),
          if (order.giftCoupon == true) ...[
            const Divider(),
            const GiftCard(),
          ],
          const Divider(),
          buildOrderItem(context,
              title: CategoryCubit.appText!.status,
              valueWidget: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: hSmallPadding,
                  vertical: vSmallPadding,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(verySmallRadius),
                  color: Colors.blue.shade50,
                ),
                child: Text(order.status == OrderStatus.waiting
                    ? Languages.of(context).waiting
                    : order.status == OrderStatus.delivered
                        ? Languages.of(context).delivered
                        : order.status == OrderStatus.cancelled
                            ? CategoryCubit.appText!.cancelled
                            : order.status == OrderStatus.onWay
                                ? Languages.of(context).onWay
                                : order.status == OrderStatus.pendingPayment
                                    ? Languages.of(context).pendingPayment
                                    : order.status ==
                                            OrderStatus.assigningDelivery
                                        ? Languages.of(context)
                                            .assigningDelivery
                                        : CategoryCubit.appText!.pendingReview),
              )),
          // const Divider(),
          // buildOrderItem(
          //   context,
          //   title: CategoryCubit.appText!.action,
          //   valueWidget: InkWell(
          //     onTap: () => Navigator.pushNamed(
          //       context,
          //       AppRouter.orderDetails,
          //       arguments: order,
          //     ),
          //     child: Container(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: hSmallPadding,
          //         vertical: vSmallPadding,
          //       ),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(verySmallRadius),
          //         color: Theme.of(context).colorScheme.secondary,
          //       ),
          //       child: Row(
          //         children: [
          //           const Icon(
          //             FontAwesomeIconsLight.eye,
          //             color: Colors.white,
          //           ),
          //           SizedBox(width: hSmallPadding),
          //           Text(
          //             CategoryCubit.appText!.view,
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .bodyText1!
          //                 .copyWith(color: Colors.white),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          if (order.delivery != null) const Divider(),
          if (order.delivery != null &&
              FirebaseAuthBloc.currentUser!.role == UserType.delivery)
            buildOrderItem(
              context,
              title: CategoryCubit.appText!.location,
              valueWidget: InkWell(
                onTap: () async {
                  // Navigator.pushNamed(
                  //   context,
                  //   AppRouter.customerLocation,
                  //   arguments: order,
                  // );
                  final location = order.customerLocation;
                  final availableMaps = await MapLauncher.installedMaps;

                  await availableMaps.first.showMarker(
                    coords: Coords(location!.lat, location.lng),
                    title: location.address,
                    zoom: location.zoom,
                  );
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
                  child: const Icon(
                    FontAwesomeIconsLight.map_marker_alt,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Container buildOrderNoteView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal:
            ScreenUtil().screenWidth > 800 ? hLargePadding : hMediumPadding,
        vertical: vMediumPadding,
      ),
      decoration: BoxDecoration(
        color: lightBgGrey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.lightBlue,
            size: 24.w,
          ),
          SizedBox(width: hMediumPadding),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '${CategoryCubit.appText!.order}  ${orderModel.orderId}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.lightBlue, height: 1.5),
                children: [
                  TextSpan(
                    text: CategoryCubit.appText!.wasPlacedOn,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey.shade800),
                  ),
                  TextSpan(
                    text: intl.DateFormat.yMMMMd()
                        .format(DateTime.parse(orderModel.dateCreated)),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey.shade800),
                  ),
                  TextSpan(
                    text: CategoryCubit.appText!.andIsCurrently,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey.shade800),
                  ),
                  TextSpan(
                    text: orderModel.status == OrderStatus.waiting
                        ? Languages.of(context).waiting
                        : orderModel.status == OrderStatus.delivered
                            ? Languages.of(context).delivered
                            : orderModel.status == OrderStatus.cancelled
                                ? CategoryCubit.appText!.cancelled
                                : orderModel.status == OrderStatus.onWay
                                    ? Languages.of(context).onWay
                                    : orderModel.status ==
                                            OrderStatus.pendingPayment
                                        ? Languages.of(context).pendingPayment
                                        : orderModel.status ==
                                                OrderStatus.assigningDelivery
                                            ? Languages.of(context)
                                                .assigningDelivery
                                            : CategoryCubit
                                                .appText!.pendingReview,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerActions extends StatelessWidget {
  const CustomerActions({
    Key? key,
    required this.orderModel,
  }) : super(key: key);

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (orderModel.status == OrderStatus.pendingReview ||
            orderModel.status == OrderStatus.assigningDelivery ||
            orderModel.status == OrderStatus.waiting)
          BlocConsumer<OrdersCubit, OrdersState>(
            listener: (context, state) {
              final OrdersCubit ordersCubit = OrdersCubit.get(context);
              if (state is ChangeOrderStatusSuccess) {
                ordersCubit.refreshOrders();
                ordersCubit.getOrders();
                Navigator.pop(context);
                // customSnackBar(
                //     context: context, message: 'Success', color: primarySwatch);
              } else if (state is ChangeOrderStatusFailed) {
                customSnackBar(context: context, message: state.error);
              }
            },
            builder: (context, state) {
              final OrdersCubit ordersCubit = OrdersCubit.get(context);
              return DefaultButton(
                text: CategoryCubit.appText!.cancel,
                onPressed: () {
                  ordersCubit.updateOrderStatus(
                      status: 'customer_cancelled', orderModel: orderModel);
                },
                buttonColor: Colors.red,
                isLoading: state is ChangeOrderStatusLoading,
              );
            },
          ),
        if (orderModel.status == OrderStatus.pendingPayment) ...[
          DefaultButton(
            text:
                '${CategoryCubit.appText!.confirm} ${CategoryCubit.appText!.price}',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMobile(orderModel: orderModel),
                  ));
            },
            buttonColor: primarySwatch,
          ),
          SizedBox(
            height: vMediumPadding,
          ),
          BlocConsumer<OrdersCubit, OrdersState>(
            listener: (context, state) {
              final OrdersCubit ordersCubit = OrdersCubit.get(context);
              if (state is ChangeOrderStatusSuccess) {
                ordersCubit.refreshOrders();
                ordersCubit.getOrders();
                Navigator.pop(context);
                // customSnackBar(
                //     context: context, message: 'Success', color: primarySwatch);
              } else if (state is ChangeOrderStatusFailed) {
                customSnackBar(context: context, message: state.error);
              }
            },
            builder: (context, state) {
              final OrdersCubit ordersCubit = OrdersCubit.get(context);
              return DefaultButton(
                text: CategoryCubit.appText!.cancel,
                onPressed: () {
                  ordersCubit.updateOrderStatus(
                      status: 'customer_cancelled',
                      orderModel: orderModel,
                      price: orderModel.price);
                },
                buttonColor: Colors.red,
                isLoading: state is ChangeOrderStatusLoading,
              );
            },
          ),
        ],
        if (orderModel.status == OrderStatus.onWay) ...[
          InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              AppRouter.trackOrder,
              arguments: orderModel,
            ),
            child: Container(
              height: 55.h,
              padding: EdgeInsets.symmetric(
                horizontal: hSmallPadding,
                vertical: vSmallPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(verySmallRadius),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIconsLight.location_arrow,
                    color: Colors.white,
                  ),
                  SizedBox(width: hSmallPadding),
                  Text(
                    CategoryCubit.appText!.trackOrder,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: vSmallPadding,
          ),
          InkWell(
            onTap: () async {
              launch(
                  'tel:${orderModel.deliveryMobile != '' ? orderModel.deliveryMobile : orderModel.delivery?.username}');
              log('tel:${orderModel.deliveryMobile}');
            },
            child: Container(
              height: 55.h,
              padding: EdgeInsets.symmetric(
                horizontal: hSmallPadding,
                vertical: vSmallPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(verySmallRadius),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIconsLight.phone,
                    color: Colors.white,
                  ),
                  SizedBox(width: hSmallPadding),
                  Text(
                    CategoryCubit.appText!.callDelivery,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class DeliveryActions extends StatelessWidget {
  const DeliveryActions({
    Key? key,
    required this.orderModel,
    required this.priceController,
  }) : super(key: key);

  final OrderModel orderModel;
  final TextEditingController? priceController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        return Column(
          children: [
            ///set price
            if (orderModel.delivery != null &&
                orderModel.status == OrderStatus.waiting) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmallHeadline(
                    title:
                        "${CategoryCubit.appText!.order} ${CategoryCubit.appText!.price}",
                  ),
                  SizedBox(
                    width: 120.w,
                    child: FilledTextFieldWithLabel(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      hintText: CategoryCubit.appText!.price,
                      autofocus: true,
                      inputAction: TextInputAction.done,
                      // requiredField: true,
                      // inputBorder: const OutlineInputBorder(
                      //   borderSide: BorderSide(color: primarySwatch,style: BorderStyle.solid,width: 2)
                      // ),
                    ),
                  )
                ],
              ),
              SizedBox(height: vMediumPadding),
              BlocConsumer<OrdersCubit, OrdersState>(
                listener: (context, state) {
                  final OrdersCubit ordersCubit = OrdersCubit.get(context);
                  if (state is ChangeOrderStatusSuccess) {
                    ordersCubit.refreshOrders();
                    ordersCubit.getOrders();
                    Navigator.pop(context);
                    // customSnackBar(
                    //     context: context,
                    //     message: 'Success',
                    //     color: Colors.green);
                  } else if (state is ChangeOrderStatusFailed) {
                    customSnackBar(context: context, message: state.error);
                  }
                },
                builder: (context, state) {
                  final OrdersCubit ordersCubit = OrdersCubit.get(context);
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: hLargePadding),
                    child: DefaultButton(
                      text:
                          '${CategoryCubit.appText!.confirm} ${CategoryCubit.appText!.price}',
                      width: double.infinity,
                      onPressed: () {
                        if (priceController!.text.isNotEmpty) {
                          ordersCubit.updateOrderStatus(
                            status: 'pending_payment',
                            price: priceController!.text,
                            orderModel: orderModel,
                          );
                        } else {
                          customSnackBar(
                              context: context,
                              message: CategoryCubit.appText!.filedIsRequired);
                        }
                      },
                      isLoading: state is ChangeOrderStatusLoading,
                      buttonColor: primarySwatch,
                    ),
                  );
                },
              ),
            ] else

            /// pending payment
            if (orderModel.delivery != null &&
                orderModel.status == OrderStatus.pendingPayment)
              Container(
                  padding: EdgeInsets.symmetric(
                      vertical: vSmallPadding, horizontal: hLargePadding),
                  margin: EdgeInsets.symmetric(horizontal: hMediumPadding),
                  decoration: BoxDecoration(
                      color: Colors.redAccent.shade100,
                      borderRadius: BorderRadius.circular(smallRadius)),
                  child: Center(
                    child: Text(Languages.of(context).pendingPayment),
                  )),

            ///while on way
            if (orderModel.delivery != null &&
                orderModel.status == OrderStatus.onWay) ...[
              SizedBox(height: vMediumPadding),
              BlocConsumer<OrdersCubit, OrdersState>(
                listener: (context, state) {
                  if (state is ChangeOrderStatusSuccess) {
                    final OrdersCubit ordersCubit = OrdersCubit.get(context);
                    ordersCubit.refreshOrders();
                    ordersCubit.getOrders();
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  final OrdersCubit ordersCubit = OrdersCubit.get(context);
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: hLargePadding,
                    ),
                    child: DefaultButton(
                      text: orderModel.status == OrderStatus.delivered
                          ? CategoryCubit.appText!.finish
                          : '${CategoryCubit.appText!.delivered} ?',
                      width: double.infinity,
                      isLoading: state is ChangeOrderStatusLoading,
                      buttonColor: orderModel.status == OrderStatus.delivered
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          title:
                              '${CategoryCubit.appText!.orderDeliveredSuccess}?',
                          btnOkText: CategoryCubit.appText!.yes,
                          btnCancelText: CategoryCubit.appText!.cancel,
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async =>
                              ordersCubit.updateOrderStatus(
                                  status: 'delivered',
                                  orderModel: orderModel,
                                  price: orderModel.price),
                        ).show();
                      },
                    ),
                  );
                },
              ),
            ],
            SizedBox(
              height: vSmallPadding,
            ),
            if (orderModel.delivery != null &&
                (orderModel.status != OrderStatus.delivered ||
                    orderModel.status != OrderStatus.cancelled))
              InkWell(
                onTap: () async {
                  launch('tel:${orderModel.customerMobile}');
                  log('tel: ${orderModel.customerMobile}');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hLargePadding,
                  ),
                  child: Container(
                    height: 55.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: hSmallPadding,
                      vertical: vSmallPadding,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(verySmallRadius),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIconsLight.phone,
                          color: Colors.white,
                        ),
                        SizedBox(width: hSmallPadding),
                        Text(
                          CategoryCubit.appText!.callCustomer,
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
        );
      },
    );
  }
}
