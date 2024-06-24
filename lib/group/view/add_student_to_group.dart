import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudentToGroupView extends StatefulWidget {
  final String groupId;
  final Function(String groupId, String studentId, Map<String, dynamic> studentInfoMap) onAddStudentToGroup;

  const AddStudentToGroupView({super.key, required this.groupId, required this.onAddStudentToGroup});

  @override
  State<AddStudentToGroupView> createState() => _AddStudentToGroupViewState();
}

class _AddStudentToGroupViewState extends State<AddStudentToGroupView> {
  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final patronymicController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedCityController;
  final sourceController = TextEditingController();
  String? selectedDirectionController;
  String? selectedTeacherController;
  final prepaymentController = TextEditingController();
  bool hasLaptop = false;
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление студента в группу'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextFormField('Фамилия', surnameController),
              _buildTextFormField('Имя', nameController),
              _buildTextFormField('Отчество', patronymicController),
              _buildTextFormField('Почта', emailController),
              _buildTextFormField('Номер телефона', phoneController),
              _buildCityDropdown(),
              _buildTextFormField('Откуда о нас узнал', sourceController),
              _buildDirectionDropdown(),
              _buildTeacherDropdown(),
              _buildTextFormField('Сумма предоплаты', prepaymentController),
              _buildLaptopRadio(),
              _buildTextFormField('Комментарий', commentController),
              ElevatedButton(
                onPressed: _onAddButtonPressed,
                child: Text('Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddButtonPressed() {
    if (surnameController.text.isEmpty ||
        nameController.text.isEmpty ||
        patronymicController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedCityController == null ||
        sourceController.text.isEmpty ||
        selectedDirectionController == null ||
        selectedTeacherController == null ||
        prepaymentController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Пожалуйста, заполните все поля",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return;
    }

    String id = randomAlphaNumeric(10);
    Map<String, dynamic> studentInfoMap = {
      "ID": id,
      "Surname": surnameController.text,
      "Name": nameController.text,
      "Patronymic": patronymicController.text,
      "Email": emailController.text,
      "Phone": phoneController.text,
      "CityID": selectedCityController,
      "Source": sourceController.text,
      "DirectionID": selectedDirectionController,
      "TeacherID": selectedTeacherController,
      "Prepayment": double.parse(prepaymentController.text),
      "HasLaptop": hasLaptop,
      "Comment": commentController.text,
    };
    widget.onAddStudentToGroup(widget.groupId, id, studentInfoMap);
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('City').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var cities = snapshot.data!.docs;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Город',
            border: OutlineInputBorder(),
          ),
          value: selectedCityController,
          onChanged: (String? newValue) {
            setState(() {
              selectedCityController = newValue!;
            });
          },
          items: cities.map((city) {
            return DropdownMenuItem<String>(
              value: city.id,
              child: Text(city['CityName']),
            );
          }).toList(),
        );
      },
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
            labelText: 'Направление',
            border: OutlineInputBorder(),
          ),
          value: selectedDirectionController,
          onChanged: (String? newValue) {
            setState(() {
              selectedDirectionController = newValue!;
            });
          },
          items: directions.map((direction) {
            return DropdownMenuItem<String>(
              value: direction.id,
              child: Text(direction['Direction']),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTeacherDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Teacher').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var teachers = snapshot.data!.docs;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Преподаватель',
            border: OutlineInputBorder(),
          ),
          value: selectedTeacherController,
          onChanged: (String? newValue) {
            setState(() {
              selectedTeacherController = newValue!;
            });
          },
          items: teachers.map((teacher) {
            return DropdownMenuItem<String>(
              value: teacher.id,
              child: Text(teacher['Surname']),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLaptopRadio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('Есть ноутбук'),
          Radio(
            value: true,
            groupValue: hasLaptop,
            onChanged: (bool? value) {
              setState(() {
                hasLaptop = value!;
              });
            },
          ),
          Text('Да'),
          Radio(
            value: false,
            groupValue: hasLaptop,
            onChanged: (bool? value) {
              setState(() {
                hasLaptop = value!;
              });
            },
          ),
          Text('Нет'),
        ],
      ),
    );
  }
}
