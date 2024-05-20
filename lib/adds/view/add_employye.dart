import 'package:firebase_diplom/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:random_string/random_string.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  Color _surnameBorderColor =
      Color.fromRGBO(103, 80, 165, 1.0); // Initial border color for email field
  Color _nameBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final patronymicController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final positionController = TextEditingController();
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 15, vertical: screenHeight / 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Фамилия'),
            TextFormField(
              controller: surnameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 50, horizontal: screenWidth / 50),
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
                    vertical: screenHeight / 50, horizontal: screenWidth / 50),
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
                    vertical: screenHeight / 50, horizontal: screenWidth / 50),
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
            ),
            SizedBox(
              height: screenHeight / 50,
            ),
            Text('Номер телефона'),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 50, horizontal: screenWidth / 50),
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
                  return 'Пожалуйста, введите номер телефона.';
                }
                return null;
              },
            ),
            SizedBox(
              height: screenHeight / 50,
            ),
            Text('Должность'),
            TextFormField(
              controller: positionController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 50, horizontal: screenWidth / 50),
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
                  return 'Пожалуйста, введите должность.';
                }
                return null;
              },
            ),
            SizedBox(
              height: screenHeight / 20,
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
                  String id = randomAlphaNumeric(10);
                  Map<String, dynamic> employeeInfoMap = {
                    "ID": id,
                    "Surname": surnameController.text,
                    "Name": nameController.text,
                    "Patronymic": patronymicController.text,
                    "PhoneNumber": phoneNumberController.text,
                    "Position": positionController.text,
                  };
                  await DatabaseMethods()
                      .addEmployeeDetails(employeeInfoMap, id)
                      .then((value) {
                    Fluttertoast.showToast(
                        msg: 'Сотрудник добавлен',
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
          ],
        ),
      ),
    );
  }
}
