// employees_controller.dart

import 'package:firebase_diplom/employyes/database/database_employee.dart';
import 'package:firebase_diplom/employyes/view/employyes_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeesController extends StatefulWidget {
  const EmployeesController({super.key});

  @override
  State<EmployeesController> createState() => _EmployeesControllerState();
}

class _EmployeesControllerState extends State<EmployeesController> {
  final DatabaseMethodsEmployee databaseMethods = DatabaseMethodsEmployee();
  late Stream<QuerySnapshot> employeeStream;

  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController patronymicController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployeeStream();
  }

  Future<void> _loadEmployeeStream() async {
    employeeStream = databaseMethods.getEmployeeDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EmployeesView(
      employeeStream: employeeStream,
      onDeleteEmployee: (id) async {
        try {
          await databaseMethods.deleteEmployeeDetail(id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Employee $id deleted successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete employee: $e')),
          );
        }
      },
      onEditEmployee: (DocumentSnapshot ds) {
        surnameController.text = ds['Surname'];
        nameController.text = ds['Name'];
        patronymicController.text = ds['Patronymic'];
        phoneNumberController.text = ds['PhoneNumber'];
        positionController.text = ds['Position'];
        _showEditDialog(ds.id);
      },
    );
  }

  void _showEditDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редактирование'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Фамилия', surnameController),
                SizedBox(height: 10),
                _buildTextField('Имя', nameController),
                SizedBox(height: 10),
                _buildTextField('Отчество', patronymicController),
                SizedBox(height: 10),
                _buildTextField('Номер телефона', phoneNumberController),
                SizedBox(height: 10),
                _buildTextField('Должность', positionController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                Map<String, dynamic> updateInfo = {
                  'Surname': surnameController.text,
                  'Name': nameController.text,
                  'Patronymic': patronymicController.text,
                  'PhoneNumber': phoneNumberController.text,
                  'Position': positionController.text,
                };
                await databaseMethods.updateEmployeeDetail(id, updateInfo);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Employee updated successfully!')),
                );
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
