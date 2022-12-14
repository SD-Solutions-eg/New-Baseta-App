import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewOnlyMapScreen extends StatefulWidget {
  final LocationModel locationModel;
  const ViewOnlyMapScreen({
    Key? key,
    required this.locationModel,
  }) : super(key: key);
  @override
  _ViewOnlyMapScreenState createState() => _ViewOnlyMapScreenState();
}

class _ViewOnlyMapScreenState extends State<ViewOnlyMapScreen> {
  late final LocationModel locationModel;

  @override
  void initState() {
    super.initState();
    locationModel = widget.locationModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CategoryCubit.appText!.location),
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
        markers: {
          Marker(
            markerId: MarkerId(locationModel.placeId),
            position: LatLng(
              locationModel.lat,
              locationModel.lng,
            ),
            infoWindow: InfoWindow(
              title: locationModel.address,
            ),
          ),
        },
      ),
    );
  }
}
