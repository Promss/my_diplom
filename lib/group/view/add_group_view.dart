import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddGroupView extends StatefulWidget {
  final Function(String id, Map<String, dynamic> groupInfoMap) onAddGroup;
  const AddGroupView({super.key, required this.onAddGroup});

  @override
  State<AddGroupView> createState() => _AddGroupViewState();
}

class _AddGroupViewState extends State<AddGroupView> {
  String? selectedDirectionController;
  final nameGroupController = TextEditingController();
  String? selectedCityController;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  String? selectedTeacherController;
  final maxCountStudentController = TextEditingController();
  final priceMonthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Добавление группы'),
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
              _buildDirectionDropdown(),
              _buildTextFormField('Название', nameGroupController),
              _buildCityDropdown(),
              _buildDateFormField('Дата с', startDateController),
              _buildDateFormField('Дата до', endDateController),
              _buildTeacherDropdown(),
              _buildTextFormField('Количество студентов', maxCountStudentController),
              _buildTextFormField('Оплата за месяц', priceMonthController),
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

  void _onAddButtonPressed() {
    if (selectedDirectionController == null) {
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

    if (selectedCityController == null) {
      Fluttertoast.showToast(
        msg: "Пожалуйста, выберите город",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (selectedTeacherController == null) {
      Fluttertoast.showToast(
        msg: "Пожалуйста, выберите преподавателя",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Пожалуйста, выберите период",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (maxCountStudentController.text.isEmpty || priceMonthController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Пожалуйста, заполните все поля",
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
    Map<String, dynamic> groupInfoMap = {
      "ID": id,
      "GroupName": nameGroupController.text,
      "GroupDirection": selectedDirectionController,
      "GroupCity": selectedCityController,
      'StartDate': DateFormat('dd-MM-yyyy').parse(startDateController.text),
      "EndDate": DateFormat('dd-MM-yyyy').parse(endDateController.text),
      'GroupTeacher': selectedTeacherController,
      'MaxCountStudent': int.parse(maxCountStudentController.text),
      'PriceMonth': double.parse(priceMonthController.text),
    };
    widget.onAddGroup(id, groupInfoMap);
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

  Widget _buildDateFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
              setState(() {
                controller.text = formattedDate;
              });
            }
          },
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
          value: selectedDirectionController,
          onChanged: (String? newValue) {
            setState(() {
              selectedDirectionController = newValue!;
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

  Widget _buildTeacherDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Teacher').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var teachers = snapshot.data!.docs;

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
          ),
          hint: const Text('Выберите преподавателя'),
          value: selectedTeacherController,
          onChanged: (String? newValue) {
            setState(() {
              selectedTeacherController = newValue!;
            });
          },
          items: teachers.map((teacher) {
            return DropdownMenuItem<String>(
              value: teacher['Surname'],
              child: Text(teacher['Surname']),
            );
          }).toList(),
        );
      },
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
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
          ),
          hint: Text('Выберите город'),
          value: selectedCityController,
          onChanged: (String? newValue) {
            setState(() {
              selectedCityController = newValue!;
            });
          },
          items: cities.map((city) {
            return DropdownMenuItem<String>(
              value: city['CityName'],
              child: Text(city['CityName']),
            );
          }).toList(),
        );
      },
    );
  }
}
