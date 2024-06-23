import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:sapri_fit/core/Snackbar.dart';
import 'package:sapri_fit/models/activity.dart';
import 'package:sapri_fit/widgets/activity_screen.dart';
import '../constants.dart';
import './CustomScaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CardData {
  final String name;
  final String data;
  final String title;
  final String description;
  final String time;
  final String distance;
  final String pace;

  CardData(this.name, this.data, this.title, this.description, this.time,
      this.distance, this.pace);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CardData? selectedCard;
  final ImagePicker _picker = ImagePicker();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} • ${dateTime.hour}:${dateTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: kBackgroundPageColor,
        currentIndex: 0,
        onTap: (index) {
          print('indice atual: $index');
        },
        body: buildCardList());
  }

  getActivities() {
    var activities = db
        .collection('persons')
        .where('userUid', isEqualTo: _firebaseAuth.currentUser!.uid)
        .get()
        .then((value) => db
            .collection('activities')
            .where('personUid', isEqualTo: value.docs.first.reference)
            .get());

    return activities;
  }

  Widget buildCardList() {
    return FutureBuilder(
      future: getActivities(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: kPrimaryColor,
            backgroundColor: kBackgroundCardColor,
          ));
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados'));
        }

        final List<Activity> activities = snapshot.data!.docs
            .map(
                (e) => Activity.fromFirestore(e.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final Activity activity = activities[index];
            return FutureBuilder(
              future: buildCard(activity),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: kPrimaryColor,
                    backgroundColor: kBackgroundCardColor,
                  ));
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar dados'));
                }

                return snapshot.data!;
              },
            );
          },
        );
      },
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
                      color: kBackgroundCardColor, fontSize: 14),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                child: Text(
                  value,
                  style: const TextStyle(
                      color: kBackgroundCardColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  editActivity(Activity activity) {
    List<dynamic> points = activity.location;
    final latlngPoints = points.map((e) => LatLng(e.latitude, e.longitude));

    List<String>? imageList = activity.image?.cast<String>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityScreen(
          uid: activity.uid,
          title: activity.title,
          description: activity.description,
          time: activity.duration,
          distance: activity.distance,
          pace: activity.pace,
          mapPoints: latlngPoints.toList(),
          image: imageList,
        ),
      ),
    );
  }

  deleteActivity(Activity activity) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Excluir atividade',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            content: const Text(
              'Deseja realmente excluir esta atividade?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: kBackgroundCardColor,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await db.collection('activities').doc(activity.uid).delete();
                  Navigator.pop(context);

                  showSnackbar(context: context, message: 'Atividade excluída');

                  setState(() {});
                },
                child: const Text(
                  'Excluir',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kBorderCardColor,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<Widget> buildCard(Activity activity) async {
    return GestureDetector(
      onTap: () {
        editActivity(activity);
      },
      child: Card(
        color: kBackgroundCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: kBorderCardColor, width: 1),
        ),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/gatinho.png'),
                  ),
                ),
                title: Text(
                  await getMyName(activity.personUid),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                subtitle: Text(
                  formatDate(activity.dateTime),
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: DropdownButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  underline: Container(),
                  dropdownColor: kBackgroundPageColor,
                  items: <String>['Editar', 'Excluir'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value == 'Editar') {
                      editActivity(activity);
                    } else {
                      deleteActivity(activity);
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(activity.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(activity.description,
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                    buildInfoCard('Tempo', activity.duration),
                    buildInfoCard('Distância', activity.distance),
                    buildInfoCard('Pace', activity.pace),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                    width: double.maxFinite,
                    height: 200,
                    padding: const EdgeInsets.all(2),
                    child: CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: getItems(activity.location, activity.image))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getItems(location, image) {
    return [
      getMap(location),
      getImages(image),
    ];
  }

  Widget getMap(location) {
    List<dynamic> points = location;
    final latlngPoints = points.map((e) => LatLng(e.latitude, e.longitude));

    return FlutterMap(
      options: MapOptions(
        initialCenter: latlngPoints.first,
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
              points: latlngPoints.toList(), // Use the converted List<LatLng>
              color: kInativeColor,
              strokeWidth: 8.0,
            ),
          ],
        ),
      ],
    );
  }

  Widget getImages(image) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: image.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(image[index]),
        );
      },
    );
  }

  Future<String> getMyName(DocumentReference<Object?> personUid) async {
    var personName = 'Usuário não encontrado';
    await db.collection('persons').doc(personUid.id).get().then((value) {
      if (value.data() != null) {
        personName = value.data()?['name'];
      }
    });

    return personName;
  }
}
