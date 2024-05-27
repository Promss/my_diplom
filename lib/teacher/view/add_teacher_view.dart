import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class AddTeacherView extends StatefulWidget {
  final Function(String id, Map<String, dynamic> teacherInfoMap) onAddTeacher;

  const AddTeacherView({super.key, required this.onAddTeacher});

  @override
  State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final patronymicController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final numberPatentController = TextEditingController();
  String? selectedDirection;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Добавление преподавателя'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth / 15, vertical: screenHeight / 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Личная информация',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(height: screenHeight / 80),
              _buildTextFormField('Фамилия', surnameController),
              _buildTextFormField('Имя', nameController),
              _buildTextFormField('Отчество', patronymicController),
              SizedBox(height: screenHeight / 80),
              Text(
                'Контактная информация',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(height: screenHeight / 80),
              _buildTextFormField('Почта', emailController),
              _buildTextFormField('Телефон', phoneNumberController),
              _buildTextFormField('Адрес', addressController),
              SizedBox(height: screenHeight / 80),
              Text(
                'Системная информация',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(height: screenHeight / 80),
              _buildTextFormField('Номер патента', numberPatentController),
              SizedBox(height: screenHeight / 80),
              _buildDirectionDropdown(),
              SizedBox(height: screenHeight / 20),
              SizedBox(
                width: double.maxFinite,
                height: screenHeight / 15,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: const Color.fromRGBO(103, 80, 165, 1.0),
                  ),
                  onPressed: _onAddButtonPressed,
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
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDirectionDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Direction').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var directions = snapshot.data!.docs;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
          ),
          hint: Text('Выберите направление'),
          value: selectedDirection,
          onChanged: (String? newValue) {
            setState(() {
              selectedDirection = newValue!;
            });
          },
          items: directions.map((direction) {
            return DropdownMenuItem<String>(
              value: direction['Direction'],
              child: Text(direction['Direction']),
            );
          }).toList(),
        );
      },
    );
  }

  void _onAddButtonPressed() {
    if (selectedDirection == null) {
      Fluttertoast.showToast(
        msg: "Пожалуйста, выберите направление",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    String id = randomAlphaNumeric(10);
    Map<String, dynamic> teacherInfoMap = {
      "ID": id,
      "Surname": surnameController.text,
      "Name": nameController.text,
      "Patronymic": patronymicController.text,
      'Email': emailController.text,
      "PhoneNumber": phoneNumberController.text,
      'Address': addressController.text,
      'NumberPatent': numberPatentController.text,
      'TeacherDirection': selectedDirection,
    };
    widget.onAddTeacher(id, teacherInfoMap);
  }
}
