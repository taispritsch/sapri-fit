import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sapri_fit/core/Snackbar.dart';
import 'package:sapri_fit/models/user.dart';
import 'package:sapri_fit/services/create_person_service.dart';
import '../constants.dart';
import './CustomScaffold.dart';
import './login_widget.dart';
import 'package:sapri_fit/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sapri_fit/models/person.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
  with SingleTickerProviderStateMixin {
  
  File? _image; 
  final picker = ImagePicker();
  late TabController _tabController;
  bool obscureText = true; 
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService(); 
  final CreatePersonService _createPersonService = CreatePersonService();
  String? _selectedSexo;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); 
    });

    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      _createPersonService.getPersonByUserUid(user.uid).then((person) {
        if (person != null) {
          setState(() {
            nameController.text = person.name;
            emailController.text = person.email;
            birthDateController.text = person.birthDate ?? '';
            _selectedSexo = person.sex;
            heightController.text = (person.height ?? 0).toString();
            weightController.text = (person.weight ?? 0).toString();
          });
        }
      });
    }
  }

  Future<void> saveUserData() async {
    if (nameController.text.isEmpty) {
      showSnackbar(context: context, message: 'O campo Nome é obrigatório.');
      return;
    }

    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      Person? existingPerson = await _createPersonService.getPersonByUserUid(user.uid);
      
      if (existingPerson != null) {
        int? height = int.tryParse(heightController.text.replaceAll(RegExp(r'[^0-9]'), ''));
        int? weight = int.tryParse(weightController.text.replaceAll(RegExp(r'[^0-9]'), ''));

        Person updatedPerson = Person(
          uid: existingPerson.uid,
          name: nameController.text,
          email: user.email ?? '',
          userUid: User(uid: user.uid, email: user.email ?? ''),
          sex: _selectedSexo,
          birthDate: birthDateController.text,
          height: height,
          weight: weight,
        );

        await _createPersonService.updatePerson(
          uid: existingPerson.uid, 
          name: updatedPerson.name,
          email: updatedPerson.email,
          sex: updatedPerson.sex,
          birthDate: updatedPerson.birthDate,
          height: updatedPerson.height,
          weight: updatedPerson.weight,
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  /*firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;*/

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
                height: 68,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: kBackgroundPageColor, width: 4.0), 
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const[
                    Tab(
                      child: Text(
                        'Meu perfil',
                        style: TextStyle(fontSize: 18),  
                      ),
                    ),
                    Tab(
                      child: Text(
                        'IMC',
                        style: TextStyle(fontSize: 18),  
                      ),
                    ),
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
                  dividerColor: const Color.fromARGB(0, 197, 24, 24),
                ),
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
                        const SizedBox(height: 20),
                        Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: kAssistantColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/images/gatinho.png'),
                                  ),
                                )
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              left: 100,
                              right: 0,
                              child: Center(
                                child: GestureDetector(
                                  onTap: getImage,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: kAssistantColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.photo,
                                      color: kBackgroundCardColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
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
                                  labelText: 'Nome*',
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
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), 
                                  color: kBackgroundCardColor,
                                ),
                                child: IgnorePointer(
                                  child: TextField(
                                    readOnly: true,
                                    controller: emailController,
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
                                      labelText: 'E-mail',
                                      fillColor: Color(0XFFFFFFFF),
                                      labelStyle: TextStyle(
                                        color: Color(0xFFFFFFA9),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              TextField(
                                controller: birthDateController,
                                inputFormatters: [DateInputFormatter()],
                                keyboardType: TextInputType.datetime,
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
                                  labelText: 'Data de nascimento',
                                  fillColor: Color(0XFFFFFFFF),
                                  labelStyle: TextStyle(
                                    color: Color(0xFFFFFFA9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          padding: const EdgeInsets.only(top: 40),
                          value: _selectedSexo,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kBorderCardColor,
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
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            labelText: 'Sexo',
                            fillColor: Color(0XFFFFFFFF),
                            labelStyle: TextStyle(
                              color: kBorderCardColor,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_drop_down, color: kBorderCardColor),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          dropdownColor: kBackgorundColor,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSexo = newValue;
                            });
                          },
                          items: <String>['Masculino', 'Feminino', 'Outro']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                                  color: kBackgroundCardColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                saveUserData().then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Dados salvos com sucesso!')),
                                  );
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erro ao salvar dados: $error')),
                                  );
                                });
                              },
                              child: const Text('Salvar'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBackgroundPageColor,
                                padding: const EdgeInsets.all(10),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kBackgroundCardColor,
                                ),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: kBorderCardColor, width: 2),
                                ),
                              ),
                               onPressed: () {
                                logout();
                              },
                              child: const Text('Deslogar'),
                            ),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              TextField(
                                controller: heightController,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              TextField(
                                controller: weightController,
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
                              onPressed: saveUserData,
                              child: const Text('Calcular'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Histórico ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, 
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: kBackgorundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Theme(
                            data: ThemeData(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                '20 de maio de 2024',
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 18,
                                ),
                              ),
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white, 
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center, 
                                          children: [
                                            Text(
                                              'Peso',
                                              style: TextStyle(
                                                color: Colors.white, 
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '65,7 kg',
                                              style: TextStyle(
                                                color: Colors.white, 
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Altura',
                                              style: TextStyle(
                                                color: Colors.white, 
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '1,75 cm',
                                              style: TextStyle(
                                                color: Colors.white, 
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Resultado',
                                            style: TextStyle(
                                              color: Colors.white, 
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            ),
                                          Text(
                                            '19',
                                            style: TextStyle(
                                              color: Colors.white, 
                                              fontSize: 16,
                                            ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30), 
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '18,5 - 24,9',
                                            style: TextStyle(
                                              color: Colors.white, 
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            ),
                                          Text(
                                            'Normal',
                                            style: TextStyle(
                                              color: Colors.white, 
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/carinha-feliz.png',
                                            fit: BoxFit.contain,
                                            height: 100,
                                            width: 50,
                                          ),
                                        ],
                                      ),
                                    ),   
                                  ],
                                ),
                              ),
                            ],
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

  logout() {
     _authenticationService.signOut();
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginWidget()),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 10) return oldValue;

    String newText = newValue.text;
    if (newValue.text.length == 2 && oldValue.text.length == 1) {
      newText = '${newValue.text}/';
    } else if (newValue.text.length == 5 && oldValue.text.length == 4) {
      newText = '${newValue.text}/';
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}


