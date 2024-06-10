import 'package:flutter/material.dart';
import 'package:sapri_fit/widgets/map_widget.dart';
import '../constants.dart';
import './CustomScaffold.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: kBackgroundPageColor,
      currentIndex: 1,
      onTap: (index) {
        print('Índice atual: $index');
      },
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: kBackgroundCardColor,
            margin: const EdgeInsets.all(20),
            child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Iniciar atividade',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.all(10),
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kBackgroundCardColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MapWidget()));
                      },
                      child: const Icon(Icons.play_arrow),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }


}
