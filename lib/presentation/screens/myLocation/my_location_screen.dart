import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/myLocation/components/map_location_view.dart';
import 'package:allin1/presentation/widgets/emptyView/empty_screen_view.dart';
import 'package:allin1/presentation/widgets/font_awesome_icons_light_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyLocationScreen extends StatefulWidget {
  const MyLocationScreen({Key? key}) : super(key: key);

  @override
  State<MyLocationScreen> createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  List<LocationModel> locations = [];
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        CategoryCubit.appText!.myAddresses,
      )),
      body: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (context, state) {
          final user = FirebaseAuthBloc.currentUser!;
          locations = user.userData.locations;
          if (locations.isNotEmpty) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(
                      horizontal: hMediumPadding, vertical: vMediumPadding)
                  .copyWith(bottom: vVeryLargePadding),
              itemBuilder: (context, index) => MapLocationView(
                  location: locations[index], hasColor: index.isEven),
              // LocationWithMapViewItem(locationModel: locations[index]),
              separatorBuilder: (context, index) =>
                  SizedBox(height: vMediumPadding),
              itemCount: locations.length,
            );
          } else {
            return EmptyScreenView(
              icon: FontAwesomeIconsLight.map_marked_alt,
              buttonText: CategoryCubit.appText!.add,
              onTap: () => Navigator.pushNamed(context, AppRouter.map),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.map);
        },
        child: Icon(
          FontAwesomeIconsLight.map_marker_plus,
          size: 30.w,
        ),
      ),
    );
  }
}

class LocationWithMapViewItem extends StatefulWidget {
  final LocationModel locationModel;
  const LocationWithMapViewItem({
    Key? key,
    required this.locationModel,
  }) : super(key: key);

  @override
  State<LocationWithMapViewItem> createState() =>
      _LocationWithMapViewItemState();
}

class _LocationWithMapViewItemState extends State<LocationWithMapViewItem> {
  GoogleMapController? mapCtrl;

  @override
  void dispose() {
    mapCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        mapCtrl?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(widget.locationModel.lat, widget.locationModel.lng),
          ),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: iconGreyColor),
              ),
              alignment: Alignment.center,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.locationModel.lat,
                    widget.locationModel.lng,
                  ),
                  zoom: widget.locationModel.zoom.toDouble(),
                ),
                onMapCreated: (controller) => mapCtrl = controller,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                mapToolbarEnabled: false,
                scrollGesturesEnabled: false,
                markers: {
                  Marker(
                    markerId: MarkerId(widget.locationModel.placeId),
                    position: LatLng(
                      widget.locationModel.lat,
                      widget.locationModel.lng,
                    ),
                    infoWindow: InfoWindow(
                      title: widget.locationModel.address,
                    ),
                  ),
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: hMediumPadding, vertical: vMediumPadding),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: iconGreyColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Address: ${widget.locationModel.address}',
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRouter.map,
                        arguments: widget.locationModel),
                    child: Icon(
                      Icons.edit,
                      size: 20.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
