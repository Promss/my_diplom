// employees_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class EmployeesView extends StatefulWidget {
  final Stream<QuerySnapshot> employeeStream;
  final Function(String) onDeleteEmployee;
  final Function(DocumentSnapshot) onEditEmployee;

  const EmployeesView({
    Key? key,
    required this.employeeStream,
    required this.onDeleteEmployee,
    required this.onEditEmployee,
  }) : super(key: key);

  @override
  State<EmployeesView> createState() => _EmployeesViewState();
}

class _EmployeesViewState extends State<EmployeesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(103, 80, 165, 1),
        onPressed: () {
          context.go('/addScreens/employee');
        },
        child: Icon(
          Icons.add,
          color: Color.fromRGBO(227, 227, 227, 1),
        ),
      ),
      backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Сотрудники'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(child: _buildEmployeeList()),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.employeeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return _buildEmployeeTile(ds);
          },
        );
      },
    );
  }

  Widget _buildEmployeeTile(DocumentSnapshot ds) {
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
            Text('Номер телефона: ${ds['PhoneNumber']}'),
            SizedBox(height: 8.0),
            Text('Должность: ${ds['Position']}'),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () => widget.onEditEmployee(ds),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDeleteEmployee(ds.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
