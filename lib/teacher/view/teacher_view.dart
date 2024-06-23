import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/teacher/controller/add_teacher_controller.dart';
import 'package:firebase_diplom/teacher/view/add_teacher_view.dart';
import 'package:firebase_diplom/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeacherView extends StatefulWidget {
  final Stream<QuerySnapshot> teacherStream;
  final Function(String) onDeleteTeacher;
  final Function(DocumentSnapshot) onEditTeacher;
  const TeacherView(
      {super.key,
      required this.teacherStream,
      required this.onDeleteTeacher,
      required this.onEditTeacher});

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(103, 80, 165, 1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTeacherController(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Color.fromRGBO(227, 227, 227, 1),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Преподаватели'),
        centerTitle: false,
      ),
      backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
      body: Column(
        children: [
          Expanded(child: _buildTeacherList()),
        ],
      ),
    );
  }

  Widget _buildTeacherList() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.teacherStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'Нет данных',
            style: TextStyle(fontSize: 25, color: Colors.grey),
          ));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return _buildTeacherTile(ds);
          },
        );
      },
    );
  }

  Widget _buildTeacherTile(DocumentSnapshot ds) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Фамилия: ${ds['Surname']}',
            ),
            SizedBox(height: 8.0),
            Text('Имя: ${ds['Name']}'),
            SizedBox(height: 8.0),
            Text('Отчество: ${ds['Patronymic']}'),
            SizedBox(height: 8.0),
            Text('Почта: ${ds['Email']}'),
            SizedBox(height: 8.0),
            Text('Номер телефона: ${ds['PhoneNumber']}'),
            SizedBox(height: 8.0),
            Text('Адрес: ${ds['Address']}'),
            SizedBox(height: 8.0),
            Text('Номер патента: ${ds['NumberPatent']}'),
            SizedBox(height: 8.0),
            Text('Направление: ${ds['TeacherDirection']}'),
            SizedBox(height: 8.0),
            Text('Номер телефона: ${ds['PhoneNumber']}'),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () => widget.onEditTeacher(ds),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDeleteTeacher(ds.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
