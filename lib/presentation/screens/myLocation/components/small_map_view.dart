import 'dart:async';

import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/order_model.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/orders/orders_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SmallMapView extends StatefulWidget {
  final LocationModel locationModel;
  final OrderModel order;
  final bool isDelivery;
  const SmallMapView({
    Key? key,
    required this.locationModel,
    required this.order,
    this.isDelivery = false,
  }) : super(key: key);

  @override
  State<SmallMapView> createState() => _SmallMapViewState();
}

class _SmallMapViewState extends State<SmallMapView> {
  late LocationModel location;
  late final OrderModel order;
  late final OrdersCubit ordersCubit;
  GoogleMapController? mapCtrl;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    ordersCubit = OrdersCubit.get(context);
    order = widget.order;
    location = widget.locationModel;
    if (!widget.isDelivery) {
      ordersCubit.getDeliveryLocation(order.delivery!.id);
      startTimer();
    }
  }

  Future<void> startTimer() async {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer.periodic(
        Duration(seconds: CategoryCubit.appDurations.updateLocationDuration),
        (_) async {
      await ordersCubit.getDeliveryLocation(order.delivery!.id);
      if (ordersCubit.delivery!.userData.mainLocation != null) {
        if (mounted) {
          setState(
              () => location = ordersCubit.delivery!.userData.mainLocation!);
        }
        _updateLocation(LatLng(ordersCubit.delivery!.userData.mainLocation!.lat,
            ordersCubit.delivery!.userData.mainLocation!.lng));
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    mapCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.locationModel.lat,
          widget.locationModel.lng,
        ),
        zoom: widget.locationModel.zoom.toDouble(),
      ),
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      mapToolbarEnabled: false,
      // scrollGesturesEnabled: true,
      onMapCreated: (controller) => mapCtrl = controller,
      onTap: (_) => Navigator.pushNamed(context, AppRouter.viewOnlyMap,
          arguments: widget.locationModel),
      markers: {
        Marker(
          markerId: MarkerId(location.placeId),
          position: LatLng(
            location.lat,
            location.lng,
          ),
          infoWindow: InfoWindow(
            title: location.address,
          ),
        ),
      },
    );
  }

  Future<void> _updateLocation(LatLng argument) async {
    mapCtrl?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          argument.latitude,
          argument.longitude,
        ),
      ),
    );
  }
}
