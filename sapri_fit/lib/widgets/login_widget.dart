import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../constants.dart';
import 'MainScreen.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(),
      ),
    );
  }
}

class _LoginWidgetState extends State<LoginWidget>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgorundColor,
      appBar: AppBar(
        backgroundColor: kBackgorundColor,
        toolbarHeight: 320,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 350,
              width: 300,
            ),
          ],
        ),
        bottom: TabBar(
          indicatorColor: kPrimaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: const Color(0XFFFFFFFF),
          unselectedLabelColor: kInativeColor,
          dividerColor: const Color(0x00FFFFFF),
          labelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Login'),
            Tab(text: 'Cadastro'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Column(children: [
                        TextField(
                          style: TextStyle(
                            height: 2.2,
                            color: Color(0xFFFFFFFF)
                          ),
                          cursorColor: Color(0XFFFFFFFF),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFFFFA9),
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: kPrimaryColor,
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'E-mail',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: Color(0xFFFFFFA9),
                            ),
                          ),
                        ),
                      ])),
                  const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(children: [
                        TextField(
                          style: TextStyle(
                            height: 2.2,
                            color: Color(0xFFFFFFFF)
                          ),
                          cursorColor: Color(0XFFFFFFFF),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFFFFFA9), width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Senha',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: Color(0xFFFFFFA9),
                            ),
                          ),
                        ),
                      ])),
                  Padding(
                    padding: const EdgeInsets.only(top: 110),
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
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          },
                          child: const Text('Entrar'),
                        ),
                      ),
                    ]),
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
                      child: Column(children: [
                        TextField(
                          style: TextStyle(
                            height: 2.2,
                            color: Color(0xFFFFFFFF)
                          ),
                          cursorColor: Color(0XFFFFFFFF),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFFFFFA9), width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Nome',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: Color(0xFFFFFFA9),
                            ),
                          ),
                        ),
                      ])),
                  const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(children: [
                        TextField(
                          style: TextStyle(
                            height: 2.2,
                            color: Color(0xFFFFFFFF)
                          ),
                          cursorColor: Color(0XFFFFFFFF),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFFFFFA9), width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'E-mail',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: Color(0xFFFFFFA9),
                            ),
                          ),
                        ),
                      ])),
                  const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(children: [
                        TextField(
                          style: TextStyle(
                            height: 2.2,
                            color: Color(0xFFFFFFFF)
                          ),
                          cursorColor: Color(0XFFFFFFFF),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFFFFFA9), width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Senha',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: Color(0xFFFFFFA9),
                            ),
                          ),
                        ),
                      ])),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
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
                          onPressed: () {},
                          child: const Text('Cadastrar'),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
