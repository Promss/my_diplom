import 'package:firebase_diplom/direction/database/database_direction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:random_string/random_string.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final Color _surnameBorderColor =
      Color.fromRGBO(103, 80, 165, 1.0); // Initial border color for email field
  final Color _nameBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
  final Color _patronymicBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
  final Color _emailBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
  final Color _phoneNumberBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final patronymicController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final sourceController = TextEditingController();
  final directionController = TextEditingController();
  final groupController = TextEditingController();
  final lecturerController = TextEditingController();
  final bool havePC = false;
  final commentController = TextEditingController();
  final locationFoundController = TextEditingController();
  final directionSelectController = TextEditingController();
  String? selectedValueLocation;
  String? selectedValueDirection;
  final List<String> optionsLocation = [
    'Instagram',
    'LinkedIn',
    'Знакомые',
    'Универ'
  ];
  List<String> optionDirection = [];

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Добавление сотрудника'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/mainScreen');
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 20, vertical: screenHeight / 100),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Личная информация',
                style: TextStyle(
                    fontSize: screenHeight / 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenHeight / 80,
              ),
              Text('Фамилия'),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 50,
                      horizontal: screenWidth / 50),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _surnameBorderColor,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите фамилию.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text('Имя'),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 50,
                      horizontal: screenWidth / 50),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _nameBorderColor,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите имя.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text('Отчество'),
              TextFormField(
                controller: patronymicController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 50,
                      horizontal: screenWidth / 50),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _patronymicBorderColor,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите имя.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text(
                'Контактная информация',
                style: TextStyle(
                    fontSize: screenHeight / 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenHeight / 80,
              ),
              Text('Почта'),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 50,
                      horizontal: screenWidth / 50),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _emailBorderColor,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите имя.';
                  } else if (!value.endsWith('@gmail.com')) {
                    return 'Пожалуйста, введите почту корректно';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text('Телефон'),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 50,
                      horizontal: screenWidth / 50),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _phoneNumberBorderColor,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите номер телефона.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text(
                'Системная информация',
                style: TextStyle(
                    fontSize: screenHeight / 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenHeight / 80,
              ),
              Text('Откуда узнали о нас'),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _surnameBorderColor,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                value: selectedValueLocation,
                items: optionsLocation.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValueLocation = newValue;
                    locationFoundController.text = newValue!;
                    print(locationFoundController.text);
                  });
                },
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Направление',
                  border: OutlineInputBorder(),
                ),
                value: selectedValueDirection,
                items: optionDirection.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValueDirection = newValue;
                    directionSelectController.text = newValue!;
                  });
                },
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text('Преподаватель'),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _surnameBorderColor,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                value: selectedValueLocation,
                items: optionsLocation.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValueLocation = newValue;
                    locationFoundController.text = newValue!;
                    print(locationFoundController.text);
                  });
                },
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text('Предоплата'),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 50,
                      horizontal: screenWidth / 50),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _phoneNumberBorderColor,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text('Комментарии'),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 50,
                      horizontal: screenWidth / 50),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _phoneNumberBorderColor,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              SizedBox(
                width: double.maxFinite,
                height: screenHeight / 15,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: const Color.fromRGBO(103, 80, 165, 1.0)),
                  onPressed: () async {
                    String id = randomAlphaNumeric(5);
                    Map<String, dynamic> directionInfoMap = {
                      "ID": id,
                      "Direction": directionController.text,
                    };
                    await DatabaseMethodsDirection()
                        .addDirectionDetails(directionInfoMap, id)
                        .then((value) {
                      Fluttertoast.showToast(
                          msg: 'Направление добавлено',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  },
                  child: Text(
                    'Добавить',
                    style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontSize: screenHeight / 50),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
