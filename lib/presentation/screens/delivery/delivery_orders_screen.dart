import 'dart:async';
import 'dart:developer';

import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

class DeliveryOrdersScreen extends StatefulWidget {
  const DeliveryOrdersScreen({Key? key}) : super(key: key);
  @override
  _DeliveryOrdersScreenState createState() => _DeliveryOrdersScreenState();
}

class _DeliveryOrdersScreenState extends State<DeliveryOrdersScreen>
    with AutomaticKeepAliveClientMixin {
  late final OrdersCubit ordersCubit;
  late LocationModel locationModel;
  Timer? ordersTimer;
  Timer? locationTimer;
  bool hasLocationPermission = false;
  bool acceptLoading = false;
  bool acceptable = true;
  List<OrderStatus> ordersStatus = [];
  bool cancelLoading = false;
  int? currentId;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      ordersCubit = OrdersCubit.get(context);
      locationModel = FirebaseAuthBloc.currentUser?.userData.mainLocation ??
          const LocationModel.create();
      // ordersCubit.refreshOrders();
      // startOrdersTimer();
      startLocationTimer();
      _isInit = true;
    }
  }

  // Future<void> startOrdersTimer() async {
  //   if (ordersTimer != null && ordersTimer!.isActive) {
  //     ordersTimer!.cancel();
  //   }
  //   ordersTimer = Timer.periodic(
  //       Duration(seconds: CategoryCubit.appDurations.deliveryOrdersDuration),
  //       (timer) {
  //     ordersCubit.refreshOrders();
  //   });
  // }

  Future<void> startLocationTimer() async {
    if (locationTimer != null && locationTimer!.isActive) {
      locationTimer!.cancel();
    }

    locationTimer = Timer.periodic(
        Duration(seconds: CategoryCubit.appDurations.updateLocationDuration),
        (timer) {
      if (ordersCubit.newDeliveryAssignedOrders.isNotEmpty) {
        log('New Location: $locationModel');
        if (hasLocationPermission) {
          _getCurrentLocation();
        } else {
          _checkLocationPermission();
        }
      }
    });
  }

  @override
  void dispose() {
    // ordersTimer?.cancel();
    locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: buildDefaultAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => ordersCubit.refreshOrders(),
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            final orders = OrdersCubit.get(context).newDeliveryAssignedOrders;
            // if (state is! OrdersGetLoading)
            {
              if (orders.isNotEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: hMediumPadding,
                      vertical: vMediumPadding,
                    ),
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
                );
              } else {
                return EmptyScreenView(
                  icon: IconlyLight.document,
                  subtitle: CategoryCubit.appText!.noOrdersSentence,
                );
              }
            }
            // else {
            //   return const LoadingSpinner();
            // }
          },
        ),
      ),
    );
  }

  Widget buildOrderView(BuildContext context, OrderModel order) {
    final isAr = Languages.of(context) is LanguageAr;
    final date = intl.DateFormat.yMMMMd(isAr ? 'ar' : 'en')
        .format(DateTime.parse(order.dateCreated));
    final time = intl.DateFormat.jm(isAr ? 'ar' : 'en')
        .format(DateTime.parse(order.dateCreated));
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRouter.orderDetails,
        arguments: order,
      ),
      child: Container(
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
            // const Divider(),
            // buildOrderItem(
            //   context,
            //   title: CategoryCubit.appText!.total,
            //   value: '${order.price} ${order.currency}',
            // ),
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
                                          : CategoryCubit
                                              .appText!.pendingReview),
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
            if (order.delivery != null && order.status == OrderStatus.onWay)
              const Divider(),
            if (order.delivery != null && order.status == OrderStatus.onWay)
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
            if (order.status == OrderStatus.assigningDelivery) const Divider(),
            if (order.status == OrderStatus.assigningDelivery)
              BlocConsumer<OrdersCubit, OrdersState>(
                listener: (context, state) async {
                  // if (state is ChangeOrderStatusSuccess) {
                  //   await ordersCubit.refreshOrders();
                  //   Navigator.pushNamed(context, AppRouter.orderDetails,
                  //       arguments: order);
                  // }
                },
                builder: (context, state) {
                  return buildOrderItem(
                    context,
                    title: CategoryCubit.appText!.newOrder,
                    valueWidget: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              acceptLoading = true;
                              currentId = order.orderId;
                              cancelLoading = false;
                            });
                            setState(() {
                              ordersStatus.clear();
                              for (final element
                                  in ordersCubit.newDeliveryAssignedOrders) {
                                if (element.orderId != order.orderId) {
                                  setState(() {
                                    // acceptable = false;
                                    // acceptLoading = false;
                                    // log('acceptable? : $acceptable');
                                    ordersStatus.add(element.status);
                                  });
                                }
                              }
                            });
                            log('ordersStatus : $ordersStatus');
                            if (ordersStatus.contains(OrderStatus.waiting) ||
                                ordersStatus
                                    .contains(OrderStatus.pendingPayment) ||
                                ordersStatus.contains(OrderStatus.onWay)) {
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
                                ? await ordersCubit.updateOrderStatus(
                                    status: 'waiting', orderModel: order)
                                : customSnackBar(
                                    context: context,
                                    message:
                                        CategoryCubit.appText!.cannotAccept);
                          },
                          child: Container(
                            width: 120.w,
                            height: 45.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(verySmallRadius),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            alignment: Alignment.center,
                            child: state is ChangeOrderStatusLoading &&
                                    acceptLoading &&
                                    currentId == order.orderId
                                ? SizedBox(
                                    width: 15.w,
                                    height: 15.w,
                                    child: const Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.white,
                                    )))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        FontAwesomeIconsLight.check_circle,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: hSmallPadding),
                                      Text(
                                        CategoryCubit.appText!.accept,
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
                          height: vVerySmallPadding,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              cancelLoading = true;
                              currentId = order.orderId;
                              acceptLoading = false;
                            });
                            await ordersCubit.updateOrderStatus(
                                status: 'delivery_cancelled',
                                orderModel: order,
                                userId: FirebaseAuthBloc.currentUser!.id
                                    .toString());
                          },
                          child: Container(
                            width: 120.w,
                            height: 45.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(verySmallRadius),
                              color: Colors.red,
                            ),
                            alignment: Alignment.center,
                            child: state is ChangeOrderStatusLoading &&
                                    cancelLoading &&
                                    currentId == order.orderId
                                ? SizedBox(
                                    width: 15.w,
                                    height: 15.w,
                                    child: const Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.white,
                                    )))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.clear_circled,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: hSmallPadding),
                                      Text(
                                        CategoryCubit.appText!.cancel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            if (order.status != OrderStatus.assigningDelivery) const Divider(),
            if (order.status != OrderStatus.assigningDelivery)
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouter.orderDetails,
                  arguments: order,
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
          ],
        ),
      ),
    );
  }

  Container buildOrderItem(
    BuildContext context, {
    required String title,
    String? value,
    Widget? valueWidget,
    Color? color,
    Color? textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: vVerySmallPadding),
      color: color,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: hSmallPadding,
            vertical: color != null ? vSmallPadding : 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title:',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: textColor,
                  ),
            ),
            if (value != null)
              Text(
                value,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: textColor,
                    ),
              )
            else if (valueWidget != null)
              valueWidget,
          ],
        ),
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    final location = Location();
    final status = await location.hasPermission();
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.deniedForever) {
      hasLocationPermission = false;

      final status = await location.requestPermission();
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.deniedForever) {
        hasLocationPermission = false;
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          title: CategoryCubit.appText!.youShouldOpenGPS,
          btnOkText: CategoryCubit.appText!.ok,
        ).show();
      } else {
        hasLocationPermission = true;
      }
    } else {
      hasLocationPermission = true;
    }
  }

  Future<void> _getLocationAddress(LatLng argument) async {
    final placeMarks = await geocoding.placemarkFromCoordinates(
        argument.latitude, argument.longitude);
    if (placeMarks.isNotEmpty) {
      // log('PlaceMarks: ${placeMarks.first}');
      final street = (placeMarks.first.street!.isNotEmpty
              ? placeMarks.first.street!
              : placeMarks.first.subThoroughfare!.isNotEmpty
                  ? placeMarks.first.subThoroughfare!
                  : '') +
          (placeMarks.first.locality!.isNotEmpty
              ? ', ${placeMarks.first.locality!}'
              : '');
      setState(() {
        locationModel = locationModel.copyWith(
          address:
              '${street.isNotEmpty ? '$street, ' : ''}${placeMarks.first.subAdministrativeArea}',
          city: placeMarks.first.administrativeArea,
          placeId: '',
          lat: argument.latitude,
          lng: argument.longitude,
          country: placeMarks.first.country,
          countryCode: placeMarks.first.isoCountryCode,
        );
      });
    } else {
      setState(() {
        locationModel = locationModel.copyWith(
          address: '',
          city: '',
          placeId: '',
          lat: argument.latitude,
          lng: argument.longitude,
        );
      });
    }
    ordersCubit.updateDeliveryLocation(locationModel);
  }

  Future<void> _getCurrentLocation() async {
    LocationData? currentLocation;
    final location = Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }
    if (currentLocation != null) {
      _getLocationAddress(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
    }
  }

  @override
  bool get wantKeepAlive => true;
}
