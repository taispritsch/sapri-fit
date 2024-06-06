import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import './CustomScaffold.dart';

class CardData {
  final String name;
  final String data;
  final String title;
  final String description;
  final String time;
  final String distance;
  final String pace;

  CardData(this.name, this.data, this.title, this.description, this.time, this.distance, this.pace);
}

List<CardData> cardList = [
  CardData('Gabrielli Sartori', '28/04/2024 • 18:16', 'Minha corridinha', 'Hoje eu corri muitooooooooo', '1h 30m 20s', '10km', '12:20 /km'),
  CardData('Taís Pritsch', '28/04/2024 • 18:16', 'Caminhada', 'Caminhada muito divertida hoje!', '1h 45m 10s', '8km', '13:30 /km'),
];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CardData? selectedCard;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: kBackgroundPageColor,
      currentIndex: 0,
      onTap: (index) {
        print('indice atual: $index');
      },
      body: selectedCard == null ? buildCardList() : buildCardDetails(selectedCard!),
    );
  }

  Widget buildCardList() {
    return ListView.builder(
      itemCount: cardList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCard = cardList[index];
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 26),
            child: Card(
              color: kBackgroundCardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: kBorderCardColor, width: 1),
              ),
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/gatinho.png'),
                    ),
                    title: Text(
                      cardList[index].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      cardList[index].data,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.more_vert, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Text(
                      cardList[index].title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      cardList[index].description,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    children: [
                      buildInfoCard('Tempo', cardList[index].time),
                      buildInfoCard('Distância', cardList[index].distance),
                      buildInfoCard('Pace', cardList[index].pace),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildInfoCard(String title, String value) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: kBackgroundCardColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  style: const TextStyle(color: kBackgroundCardColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardDetails(CardData card) {
    return Scaffold(
      backgroundColor: kBackgroundPageColor,
      appBar: AppBar(
        backgroundColor: kBackgroundPageColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              selectedCard = null;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
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
                    fontSize: 20,
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
                controller: TextEditingController(text: card.title),
                readOnly: true,
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
                controller: TextEditingController(text: card.description),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  buildInfoCard('Tempo', card.time),
                  buildInfoCard('Distância', card.distance),
                  buildInfoCard('Pace', card.pace),
                ],
              ),
            ],
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
              final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
              if (photo != null) {
                print('lalalala: ${photo.path}');
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
              final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
              if (photo != null) {
                print('abababbaa: ${photo.path}');
              }
            },
          ),
        ],
        child: const Icon(Icons.add),
      ),
    );
  }
}
