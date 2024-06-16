import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sapri_fit/constants.dart';
import 'package:sapri_fit/widgets/activity_screen.dart';
import 'package:sapri_fit/widgets/record_screen.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidget();
}

class _MapWidget extends State<MapWidget> {
  final MapController _mapController = MapController();
  final List<double> _initialPosition = [];
  final List<double> _myPosition = [];
  late final List<LatLng> _points = [];
  late bool _startActivitiy = false;
  late StreamSubscription<Position> _positionStream;
  bool _openScreen = true;
  double _km = 0;
  double _pace = 0;
  String _minutesTimer = "";
  late Stopwatch _stopwatch;
  late Timer t;

  Future<Position> _determinePosition() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled return an error message
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permissions are granted, return the current location
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> getInitialPosition() async {
    if (!_openScreen) {
      return false;
    }

    Position position = await _determinePosition();

    setState(() {
      _stopwatch.start();
      _initialPosition.add(position.latitude);
      _initialPosition.add(position.longitude);
      _myPosition.add(position.latitude);
      _myPosition.add(position.longitude);
      _points.add(LatLng(position.latitude, position.longitude));
      _mapController.move(LatLng(_myPosition[0], _myPosition[1]), 18.0);
      _openScreen = false;
    });

    return true;
  }

  void getLocationUpdates() {
    if (_startActivitiy) {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      );

      _positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position position) {

         if (position.latitude == _myPosition[0] &&
            position.longitude == _myPosition[1]) {
          return;
        }

        setState(() {
          _myPosition.clear();
          _myPosition.add(position.latitude);
          _myPosition.add(position.longitude);
          _points.add(LatLng(position.latitude, position.longitude));
          _mapController.move(LatLng(_myPosition[0], _myPosition[1]), 18.0);
        });

        calculateDistance();
      });
    } else {
      stopListening();
    }
  }

  void stopListening() {
    _positionStream?.cancel();
  }

  changeActivityMode() {
    setState(() {
      _startActivitiy = !_startActivitiy;
      if (_startActivitiy) {
        getLocationUpdates();
      } else {
        stopListening();
        _stopwatch.stop();
        formatTimer();
        calculatePace();
        showDialogAlert();
      }
    });
  }

  calculateDistance() {
    var pointsLatitude = _points.map((e) => e.latitude).toList();
    var pointsLongitude = _points.map((e) => e.longitude).toList();

    double startLatitude = pointsLatitude.length > 2
        ? pointsLatitude[pointsLatitude.length - 2]
        : _initialPosition[0];
    double startLongitude = pointsLongitude.length > 2
        ? pointsLongitude[pointsLongitude.length - 2]
        : _initialPosition[1];
    double endLatitude = _myPosition[0];
    double endLongitude = _myPosition[1];

    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    setState(() {
      var distance = _km;

      distance += round((distanceInMeters / 1000), decimals: 2);
      _km = round(distance);
    });
  }

  String formatTimer() {
    setState(() {
      _minutesTimer = "${_stopwatch.elapsed.inHours}h ${_stopwatch.elapsed.inMinutes.remainder(60)}m ${(_stopwatch.elapsed.inSeconds.remainder(60))}s";
    });

    return _minutesTimer;
  }

  calculatePace() {
    if (_km == 0) {
      return;
    }

    var minutes = _stopwatch.elapsed.inMinutes;
    setState(() {
      _pace = round((minutes / _km), decimals: 2);
    });
  }

  saveActivity() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActivityScreen(
                  title: "",
                  description: "",
                  time: _minutesTimer,
                  distance: _km,
                  pace: _pace,
                  mapPoints: _points,
                )));
  }

  showDialogAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Atividade finalizada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Deseja salvar a atividade?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: kBackgroundCardColor,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecordScreen()));
              },
              child: const Text(
                'Descartar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                saveActivity();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(kPrimaryColor),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kBackgroundCardColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    t = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    changeActivityMode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgorundColor,
          leading: Image.asset('assets/images/logo.png'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                color: kBorderCardColor,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Distância',
                          style: TextStyle(
                            color: kBackgroundCardColor,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '$_km km',
                          style: const TextStyle(
                            color: kBackgroundCardColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Tempo',
                          style: TextStyle(
                            color: kBackgroundCardColor,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          formatTimer(),
                          style: const TextStyle(
                            color: kBackgroundCardColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildMap(),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
            height: 60,
            width: 60,
            child: FloatingActionButton(
                onPressed: () {
                  changeActivityMode();
                },
                backgroundColor: kPrimaryColor,
                tooltip: 'Increment',
                child: Icon(
                  _startActivitiy ? Icons.stop : Icons.play_arrow,
                  color: kBackgroundCardColor,
                ))));
  }

  Widget _buildMap() {
    return FutureBuilder(
        future: getInitialPosition(),
        builder: (context, snapshot) {
          if (_initialPosition.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
                backgroundColor: kBackgroundCardColor,
              ),
            );
          }
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(_initialPosition[0], _initialPosition[1]),
              minZoom: 19,
              maxZoom: 19,
              initialZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                alignment: const Alignment(0, -0.4),
                markers: [
                  Marker(
                    point: List<LatLng>.from(_points).last,
                    width: 100,
                    height: 100,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: kBackgroundPageColor,
                      size: 40,
                    ),
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: List<LatLng>.from(_points),
                    color: kInativeColor,
                    strokeWidth: 8.0,
                  ),
                ],
              ),
            ],
          );
        });
  }
}
