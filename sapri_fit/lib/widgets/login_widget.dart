// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sapri_fit/core/Snackbar.dart';
import 'package:sapri_fit/services/authentication_service.dart';
import 'package:email_validator/email_validator.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool obscureText = true; 

  final AuthenticationService _authenticationService = AuthenticationService();

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

  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
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
          Form(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(children: [
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(
                                height: 2.2, color: Color(0xFFFFFFFF)),
                            cursorColor: const Color(0XFFFFFFFF),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kBorderCardColor,
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
                                color: kBorderCardColor,
                              ),
                            ),
                          ),
                        ])),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(children: [
                          TextFormField(
                            controller: _passwordController,
                            obscureText: obscureText, 
                            style: const TextStyle(
                                height: 2.2, color: Color(0xFFFFFFFF)),
                            cursorColor: const Color(0XFFFFFFFF),
                            decoration:  InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBorderCardColor, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              contentPadding: EdgeInsets.all(10),
                              labelText: 'Senha',
                              fillColor: const Color(0XFFFFFFFF),
                              labelStyle: const TextStyle(
                                color: kBorderCardColor,
                              ),
                              suffixIcon: IconButton(
                                    icon: Icon(
                                      obscureText ? Icons.visibility : Icons.visibility_off, 
                                      color: kInativeColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
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
                              sendLogin();
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
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(children: [
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(
                              height: 2.2, color: Color(0xFFFFFFFF)),
                          cursorColor: const Color(0XFFFFFFFF),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kBorderCardColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Nome',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: kBorderCardColor,
                            ),
                          ),
                        ),
                      ])),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(children: [
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                              height: 2.2, color: Color(0xFFFFFFFF)),
                          cursorColor: const Color(0XFFFFFFFF),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kBorderCardColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'E-mail',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: kBorderCardColor,
                            ),
                          ),
                        ),
                      ])),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(children: [
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(
                              height: 2.2, color: Color(0xFFFFFFFF)),
                          cursorColor: const Color(0XFFFFFFFF),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kBorderCardColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Senha',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: kBorderCardColor,
                            ),
                          ),
                          obscureText: true,
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
                                  color: kBackgroundCardColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            sendRegister();
                          },
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

  sendLogin() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      return;
    } else {
      _authenticationService.signIn(email: email, password: password).then(
        (String? error) {
          if (error != null) {
            showSnackbar(context: context, message: error);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
        },
      );
    }
  }

  sendRegister() {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackbar(context: context, message: 'Todos os campos são obrigatórios');
      return;
    } else if(!isValidEmail(email)){
      showSnackbar(context: context, message: "Por favor, insira um e-mail válido.");
      return;
    } else if (password.length < 8) {
      showSnackbar(context: context, message: 'A senha deve ter pelo menos 8 caracteres');
      return;
    }else {
      _authenticationService
          .signUp(email: email, password: password, name: name)
          .then((String? error) async {
        if (error != null) {
          showSnackbar(context: context, message: error);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      });
    }
  }
}
