import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? _center;
  BitmapDescriptor? _markerIcon;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services disabled');
      return;
    }

    final PermissionStatus permission = await Permission.location.request();
    if (permission == PermissionStatus.denied) {
      _showSnackBar('Location permission denied');
      return;
    }
    if (permission == PermissionStatus.permanentlyDenied) {
      _showSnackBar('Location permissions are permanently denied');
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _loadMarkerIcon() async {
    final markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/marker_icon.png',
    );

    setState(() {
      _markerIcon = markerIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: _buildMap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        if (_center != null)
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center!,
              zoom: 15.0,
            ),
            mapType: MapType.normal,
            markers: {
              if (_markerIcon != null)
                Marker(
                  markerId: MarkerId('current_location'),
                  position: _center!,
                  icon: _markerIcon!,
                  anchor: Offset(0.5, 0.5),
                ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              // Optional: You can customize the map controller settings here
            },
          ),
        if (_center == null)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}