import 'dart:developer';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:location/location.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

class MapScreen extends StatefulWidget {
  final LocationModel? locationModel;
  const MapScreen({
    Key? key,
    required this.locationModel,
  }) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final LocationModel locationModel;
  late final CustomerCubit customerCubit;
  GoogleMapController? mapCtrl;
  LocationModel? selectedLocation;
  bool newLocation = false;
  bool isLoading = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      if (widget.locationModel == null) {
        newLocation = true;
        locationModel = const LocationModel.create();
      } else {
        newLocation = false;
        locationModel = widget.locationModel!;
      }
      customerCubit = CustomerCubit.get(context);

      _isInit = true;
    }
  }

  @override
  void dispose() {
    mapCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: hSmallPadding),
          child: buildSearchBar(),
        ),
        // Text(CategoryCubit.appText!.selectLocation),
        actions: [
          if (selectedLocation != null)
            BlocConsumer<CustomerCubit, CustomerState>(
              listener: (context, state) {
                if (state is UpdateLiveLocationSuccess) {
                  customSnackBar(
                    context: context,
                    message: CategoryCubit.appText!.locationUpdated,
                    color: Theme.of(context).colorScheme.primary,
                  );
                  Navigator.pop(context);
                } else if (state is UpdateLiveLocationFailed) {
                  customSnackBar(context: context, message: state.error);
                }
              },
              builder: (context, state) {
                if (state is UpdateParentLoading || isLoading) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: hMediumPadding, vertical: vMediumPadding),
                      child: SizedBox(
                        width: 25.w,
                        height: 25.w,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else {
                  return TextButton.icon(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      final List<LocationModel> locations = [
                        ...FirebaseAuthBloc.currentUser!.userData.locations
                      ];
                      if (newLocation) {
                        locations.add(selectedLocation!);
                        final newLocationsMap =
                            selectedLocation!.locationsToMap(locations);
                        log('New Locations Map: $newLocationsMap');
                        await customerCubit.updateMyLocations(
                            locationsMap: newLocationsMap);
                      } else {
                        final index = locations.indexOf(locationModel);
                        locations.removeAt(index);
                        locations.insert(index, selectedLocation!);
                        final newLocationsMap =
                            selectedLocation!.locationsToMap(locations);
                        log('New Locations Map: $newLocationsMap');
                        await customerCubit.updateMyLocations(
                            locationsMap: newLocationsMap);
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: Text(CategoryCubit.appText!.saveChanges),
                  );
                }
              },
            ),
        ],
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            locationModel.lat,
            locationModel.lng,
          ),
          zoom: locationModel.zoom.toDouble(),
        ),
        onMapCreated: (controller) => mapCtrl = controller,
        markers: {
          Marker(
            markerId: MarkerId(locationModel.placeId),
            position: LatLng(
              selectedLocation?.lat ?? locationModel.lat,
              selectedLocation?.lng ?? locationModel.lng,
            ),
            infoWindow: InfoWindow(
              title: selectedLocation?.address ?? locationModel.address,
            ),
          ),
        },
        onTap: (argument) {
          //Change marker Position...
          _updateLocation(argument);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _currentLocation,
        // label: Text(CategoryCubit.appText!.location),
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget buildSearchBar() {
    return FilledTextFieldWithLabel(
      hintText: CategoryCubit.appText!.search,
      height: 45.w,
      readOnly: true,
      onTap: () => showPlacePicker(),
      prefixIcon: Icon(
        IconlyLight.search,
        size: 20.w,
      ),
    );
  }

  Future<void> showPlacePicker() async {
    final LocationResult? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(googleMapsKey
            // localizationItem: LocalizationItem(languageCode: 'ar',findingPlace: 'جاري البحث',nearBy: "أماكن بالقرب",
            // noResultsFound: "لا يوجد نتائج",tapToSelectLocation: "اضغط لاختيار هذا الموقع",unnamedLocation: "بدون اسم")
            )));
    _updateLocation(result!.latLng!);
    // Handle the result in your way
    print('-------${result.latLng}');
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
    final placeMarks = await geocoding.placemarkFromCoordinates(
        argument.latitude, argument.longitude);
    if (placeMarks.isNotEmpty) {
      log('PlaceMarks: ${placeMarks.first}');
      final street = (placeMarks.first.street!.isNotEmpty
              ? placeMarks.first.street!
              : placeMarks.first.subThoroughfare!.isNotEmpty
                  ? placeMarks.first.subThoroughfare!
                  : '') +
          (placeMarks.first.locality!.isNotEmpty
              ? ', ${placeMarks.first.locality!}'
              : '');
      setState(() {
        selectedLocation = locationModel.copyWith(
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
        selectedLocation = locationModel.copyWith(
          address: '',
          city: '',
          placeId: '',
          lat: argument.latitude,
          lng: argument.longitude,
        );
      });
    }
  }

  Future<void> _currentLocation() async {
    LocationData? currentLocation;
    final location = Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }
    if (currentLocation != null) {
      _updateLocation(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
    }
  }
}
