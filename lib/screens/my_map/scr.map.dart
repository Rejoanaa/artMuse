import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/my_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapIFrameScreen extends StatefulWidget {
  const MapIFrameScreen({super.key});

  @override
  State<MapIFrameScreen> createState() => _MapIFrameScreenState();
}

class _MapIFrameScreenState extends State<MapIFrameScreen> {
  String locationmsg = 'Current location';

  late String lat;
  late String long;

  //String? lat;
  //String? long;

  @override
  void initState() {
    lat = '0.00';
    long = '0.00';
    super.initState();
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied permanently');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _livelocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationmsg = 'Latitude: $lat, Longitude: $long';
      });
    });
  }

  Future<void> openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    await canLaunchUrlString(googleURL)
        ? launchUrlString(googleURL)
        : throw 'could not launch $googleURL';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: MyColors.secondColor,
      title: Text("Map Iframe", style:  TextStyle(color: Colors.white),)),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              locationmsg,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  getCurrentLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';

                    setState(() {
                      locationmsg = 'Latitude: $lat, Longitude: $long';
                    });

                    _livelocation();
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.secondColor),
                child: const Text('Get user location')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  openMap(lat, long);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.secondColor),
                child: const Text('Open google map'))
          ]),
        ),
      );
}
