import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/group/database/database.dart';

class AddExistingStudentToGroupView extends StatefulWidget {
  final String groupId;
  final DatabaseMethodsGroup databaseMethodsGroup = DatabaseMethodsGroup();

  AddExistingStudentToGroupView({super.key, required this.groupId});

  @override
  State<AddExistingStudentToGroupView> createState() => _AddExistingStudentToGroupViewState();
}

class _AddExistingStudentToGroupViewState extends State<AddExistingStudentToGroupView> {
  final selectedStudents = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление существующих студентов в группу'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              for (var studentId in selectedStudents) {
                await widget.databaseMethodsGroup.addExistingStudentToGroup(widget.groupId, studentId);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Student').snapshots(),
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
    final studentId = ds.id;
    final isSelected = selectedStudents.contains(studentId);
    return ListTile(
      title: Text('${ds['Surname']} ${ds['Name']}'),
      subtitle: Text('Почта: ${ds['Email']}'),
      trailing: Checkbox(
        value: isSelected,
        onChanged: (bool? selected) {
          setState(() {
            if (selected!) {
              selectedStudents.add(studentId);
            } else {
              selectedStudents.remove(studentId);
            }
          });
        },
      ),
    );
  }
}
