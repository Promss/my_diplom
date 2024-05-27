import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/teacher/database/database_teacher.dart';
import 'package:firebase_diplom/teacher/view/teacher_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherController extends StatefulWidget {
  const TeacherController({super.key});

  @override
  State<TeacherController> createState() => _TeacherControllerState();
}

class _TeacherControllerState extends State<TeacherController> {
  final DatabaseMethodsTeacher databaseMethodsTeacher =
      DatabaseMethodsTeacher();
  late Stream<QuerySnapshot> teacherStream;
  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final patronymicController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final numberPatentController = TextEditingController();
  String? selectedDirection;

  @override
  void initState() {
    super.initState();
    _loadTeacherStream();
  }

  Future<void> _loadTeacherStream() async {
    teacherStream = databaseMethodsTeacher.getEmployeeDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TeacherView(
      teacherStream: teacherStream,
      onDeleteTeacher: (id) async {
        try {
          await databaseMethodsTeacher.deleteTeacherDetail(id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Teacher $id deleted successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete teacher: $e')),
          );
        }
      },
      onEditTeacher: (DocumentSnapshot ds) {
        surnameController.text = ds['Surname'];
        nameController.text = ds['Name'];
        patronymicController.text = ds['Patronymic'];
        emailController.text = ds['Email'];
        phoneNumberController.text = ds['PhoneNumber'];
        addressController.text = ds['Address'];
        numberPatentController.text = ds['NumberPatent'];
        selectedDirection =
            ds['TeacherDirection']; // обновляем поле направления
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
                _buildTextField('Почта', emailController),
                SizedBox(height: 10),
                _buildTextField('Номер телефона', phoneNumberController),
                SizedBox(height: 10),
                _buildTextField('Адрес', addressController),
                SizedBox(height: 10),
                _buildTextField('Номер патента', numberPatentController),
                SizedBox(height: 10),
                _buildDirectionDropdown(),
                SizedBox(height: 10),
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
                  'Email': emailController.text,
                  'PhoneNumber': phoneNumberController.text,
                  'Address': addressController.text,
                  'NumberPatent': numberPatentController.text,
                  'TeacherDirection': selectedDirection
                };
                await databaseMethodsTeacher.updateTeacherDetail(
                    id, updateInfo);
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
}
