import 'package:flutter/material.dart';
import '../constants.dart';
import './CustomScaffold.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      currentIndex: 2,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/screen1');
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
      },
      backgroundColor: kBackgroundPageColor,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 48,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: kBackgroundPageColor, width: 2.0),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: const[
                  Tab(text: 'Meu perfil'),
                  Tab(text: 'IMC'),
                ],
                indicator: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: kPrimaryColor,
                      width: 4.0,
                    ),
                  ),
                ),
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.white,
                unselectedLabelStyle: const TextStyle(
                  decoration: TextDecoration.none,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/images/gatinho.png'),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kAssistantColor,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: () {
                                    // logica para trocar foto
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              TextField(
                                style: TextStyle(
                                  height: 2.2,
                                  color: Color(0xFFFFFFFF),
                                ),
                                cursorColor: Color(0XFFFFFFFF),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFFFA9),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Nome',
                                  fillColor: Color(0XFFFFFFFF),
                                  labelStyle: TextStyle(
                                    color: Color(0xFFFFFFA9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              TextField(
                                style: TextStyle(
                                  height: 2.2,
                                  color: Color(0xFFFFFFFF),
                                ),
                                cursorColor: Color(0XFFFFFFFF),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFFFA9),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'E-mail',
                                  fillColor: Color(0XFFFFFFFF),
                                  labelStyle: TextStyle(
                                    color: Color(0xFFFFFFA9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              TextField(
                                style: TextStyle(
                                  height: 2.2,
                                  color: Color(0xFFFFFFFF),
                                ),
                                cursorColor: Color(0XFFFFFFFF),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFFFA9),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Senha',
                                  fillColor: Color(0XFFFFFFFF),
                                  labelStyle: TextStyle(
                                    color: Color(0xFFFFFFA9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              TextField(
                                style: TextStyle(
                                  height: 2.2,
                                  color: Color(0xFFFFFFFF),
                                ),
                                cursorColor: Color(0XFFFFFFFF),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFFFA9),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Altura',
                                  fillColor: Color(0XFFFFFFFF),
                                  labelStyle: TextStyle(
                                    color: Color(0xFFFFFFA9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              TextField(
                                style: TextStyle(
                                  height: 2.2,
                                  color: Color(0xFFFFFFFF),
                                ),
                                cursorColor: Color(0XFFFFFFFF),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFFFA9),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Peso',
                                  fillColor: Color(0XFFFFFFFF),
                                  labelStyle: TextStyle(
                                    color: Color(0xFFFFFFA9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.all(10),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF404040),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Implemente a lógica do botão aqui
                              },
                              child: const Text('Calcular'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}