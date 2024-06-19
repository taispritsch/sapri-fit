import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:sapri_fit/constants.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sapri_fit/services/authentication_service.dart';
import 'package:sapri_fit/services/create_activity_service.dart';
import 'package:sapri_fit/widgets/CustomScaffold.dart';
import 'package:sapri_fit/widgets/MainScreen.dart';

class ActivityScreen extends StatefulWidget {
  final String title;
  final String description;
  final String time;
  final double distance;
  final double pace;
  final List<LatLng> mapPoints;

  const ActivityScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.time,
      required this.distance,
      required this.pace,
      required this.mapPoints});

  @override
  State<ActivityScreen> createState() => _ActivityScreen();
}

class _ActivityScreen extends State<ActivityScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late MapController _mapController;
  List<File> _images = [];
  final List<String> _imagesUrl = [];

  final CreateActivityService _createActivityService = CreateActivityService();

  final AuthenticationService _authenticationService = AuthenticationService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: kBackgroundPageColor,
      currentIndex: 1,
      onTap: (index) {
        print('Índice atual: $index');
      },
      body: buildCardDetails(),
    );
  }

  showDialogAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Descartar alterações',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Deseja descartar as alterações desta atividade?',
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
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
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
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(kPrimaryColor),
              ),
              child: const Text(
                'Cancelar',
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

  saveActivity() async {
    if (_formKey.currentState!.validate()) {
      for (var image in _images) {
        await _createActivityService
            .uploadImage(image.path, image.path)
            .then((value) {
          setState(() {
            _imagesUrl.add(value);
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao salvar imagem'),
            ),
          );
        });
      }

      _createActivityService
          .createActivity(
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: DateTime.now().toString(),
        pace: widget.pace.toString(),
        distance: widget.distance.toString(),
        duration: widget.time,
        userUid: _authenticationService.getCurrentUser()!.uid,
        image: _imagesUrl,
        location: widget.mapPoints
            .map((e) => GeoPoint(e.latitude, e.longitude))
            .toList(),
      )
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Atividade salva com sucesso'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar atividade'),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      });
    }
  }

  Widget buildCardDetails() {
    return Scaffold(
      backgroundColor: kBackgroundPageColor,
      appBar: AppBar(
        backgroundColor: kBackgroundPageColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            showDialogAlert();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Atividade',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(
                    height: 2.2,
                    color: Color(0xFFFFFFFF),
                  ),
                  cursorColor: const Color(0XFFFFFFFF),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFFFFA9),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Título',
                    fillColor: Color(0XFFFFFFFF),
                    labelStyle: TextStyle(
                      color: Color(0xFFFFFFA9),
                    ),
                  ),
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O título é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(
                    height: 2.2,
                    color: Color(0xFFFFFFFF),
                  ),
                  cursorColor: const Color(0XFFFFFFFF),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFFFFA9),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Descrição',
                    fillColor: Color(0XFFFFFFFF),
                    labelStyle: TextStyle(
                      color: Color(0xFFFFFFA9),
                    ),
                  ),
                  controller: _descriptionController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    buildInfoCard('Tempo', widget.time),
                    buildInfoCard('Distância', '${widget.distance} km'),
                    buildInfoCard('Pace', '${widget.pace} min/km'),
                  ],
                ),
                Row(
                  children: [
                    buildMapCard(),
                  ],
                ),
                Row(
                  children: [
                    buildImageCard(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.all(10),
                            textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF404040)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          saveActivity();
                        },
                        child: const Text('Salvar'),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: kPrimaryColor,
        overlayOpacity: 0,
        spacing: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.photo_camera, color: kBackgroundCardColor),
            backgroundColor: kAssistantColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () async {
              final XFile? photo = await _picker.pickImage(
                  source: ImageSource.camera, imageQuality: 50);
              if (photo != null) {
                setState(() {
                  _images.add(File(photo.path));
                });
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.photo, color: kBackgroundCardColor),
            backgroundColor: kAssistantColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () async {
              final XFile? photo = await _picker.pickImage(
                  source: ImageSource.gallery, imageQuality: 50);
              if (photo != null) {
                setState(() {
                  _images.add(File(photo.path));
                });
              }
            },
          ),
        ],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildImageCard() {
    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (_images.isEmpty) {
            return const SizedBox();
          }
          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Card(
                color: const Color(0x00FFFFFF),
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Imagens',
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                      color: kBorderCardColor, width: 1),
                                ),
                                child: Image.file(
                                  _images[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildMapCard() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Card(
          color: kBorderCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: kBorderCardColor, width: 1),
          ),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: buildMap(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.mapPoints.first,
        minZoom: 12,
        maxZoom: 19,
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: widget.mapPoints,
              color: kInativeColor,
              strokeWidth: 8.0,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
        child: Card(
          color: kBorderCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: kBorderCardColor, width: 1),
          ),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: kBackgroundCardColor, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                child: Text(
                  value,
                  style: const TextStyle(
                      color: kBackgroundCardColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
