import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/group/controller/add_group_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupView extends StatefulWidget {
  final Stream<QuerySnapshot> groupStream;
  final Function(String) onDeleteGroup;
  final Function(DocumentSnapshot) onEditGroup;
  const GroupView(
      {super.key,
      required this.groupStream,
      required this.onDeleteGroup,
      required this.onEditGroup});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(103, 80, 165, 1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGroupController(),
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
        title: const Text('Группы'),
        centerTitle: false,
      ),
      backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
      body: Column(
        children: [
          Expanded(child: _buildGroupList()),
        ],
      ),
    );
  }

  Widget _buildGroupList() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.groupStream,
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
            return _buildGroupTile(ds);
          },
        );
      },
    );
  }

  Widget _buildGroupTile(DocumentSnapshot ds) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Название: ${ds['GroupName']}',
            ),
            SizedBox(height: 8.0),
            Text('Направление: ${ds['GroupDirection']}'),
            SizedBox(height: 8.0),
            Text('Город: ${ds['GroupCity']}'),
            SizedBox(height: 8.0),
            Text(
                'Дата с: ${DateFormat('dd-MM-yyyy').format((ds['StartDate'] as Timestamp).toDate())}'),
            Text(
                'Дата до: ${DateFormat('dd-MM-yyyy').format((ds['EndDate'] as Timestamp).toDate())}'),
            SizedBox(height: 8.0),
            Text('Преподаватель: ${ds['GroupTeacher']}'),
            SizedBox(height: 8.0),
            Text('Количество студентов: ${ds['MaxCountStudent']}'),
            SizedBox(height: 8.0),
            Text('Стоимость в месяц: ${ds['PriceMonth']}'),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () => widget.onEditGroup(ds),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDeleteGroup(ds.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
