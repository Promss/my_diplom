// add_employee_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_string/random_string.dart';

class AddEmployeeView extends StatefulWidget {
  final Function(String id, Map<String, dynamic> employeeInfoMap) onAddEmployee;

  const AddEmployeeView({super.key, required this.onAddEmployee});

  @override
  State<AddEmployeeView> createState() => _AddEmployeeViewState();
}

class _AddEmployeeViewState extends State<AddEmployeeView> {
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth / 15, vertical: screenHeight / 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField('Фамилия', surnameController),
            _buildTextFormField('Имя', nameController),
            _buildTextFormField('Отчество', patronymicController),
            _buildTextFormField('Номер телефона', phoneNumberController),
            _buildTextFormField('Должность', positionController),
            SizedBox(height: screenHeight / 20),
            SizedBox(
              width: double.maxFinite,
              height: screenHeight / 15,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: const Color.fromRGBO(103, 80, 165, 1.0),
                ),
                onPressed: _onAddButtonPressed,
                child: Text(
                  'Добавить',
                  style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: screenHeight / 50),
                ),
              ),
            ),
          ],
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

  void _onAddButtonPressed() {
    String id = randomAlphaNumeric(10);
    Map<String, dynamic> employeeInfoMap = {
      "ID": id,
      "Surname": surnameController.text,
      "Name": nameController.text,
      "Patronymic": patronymicController.text,
      "PhoneNumber": phoneNumberController.text,
      "Position": positionController.text,
    };
    widget.onAddEmployee(id, employeeInfoMap);
  }
}
