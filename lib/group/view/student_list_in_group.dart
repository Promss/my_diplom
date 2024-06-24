import 'package:firebase_diplom/group/view/add_existing_student_to_group_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/group/database/database.dart';

class StudentListInGroupView extends StatelessWidget {
  final String groupId;
  final DatabaseMethodsGroup databaseMethodsGroup = DatabaseMethodsGroup();

  StudentListInGroupView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Студенты в группе'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddExistingStudentToGroupView(groupId: groupId),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: databaseMethodsGroup.getStudentsInGroup(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Нет данных'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return _buildStudentTile(ds);
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentTile(DocumentSnapshot ds) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Фамилия: ${ds['Surname']}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text('Имя: ${ds['Name']}'),
            SizedBox(height: 4.0),
            Text('Отчество: ${ds['Patronymic']}'),
            SizedBox(height: 4.0),
            Text('Почта: ${ds['Email']}'),
            SizedBox(height: 4.0),
            Text('Номер телефона: ${ds['Phone']}'),
            SizedBox(height: 4.0),
            Text('Город: ${ds['CityID']}'), // Можно добавить логику для отображения названия города
            SizedBox(height: 4.0),
            Text('Откуда узнал: ${ds['Source']}'),
            SizedBox(height: 4.0),
            Text('Направление: ${ds['DirectionID']}'), // Можно добавить логику для отображения названия направления
            SizedBox(height: 4.0),
            Text('Преподаватель: ${ds['TeacherID']}'), // Можно добавить логику для отображения фамилии преподавателя
            SizedBox(height: 4.0),
            Text('Сумма предоплаты: ${ds['Prepayment']}'),
            SizedBox(height: 4.0),
            Text('Есть ноутбук: ${ds['HasLaptop'] ? "Да" : "Нет"}'),
            SizedBox(height: 4.0),
            Text('Комментарий: ${ds['Comment']}'),
          ],
        ),
      ),
    );
  }
}
