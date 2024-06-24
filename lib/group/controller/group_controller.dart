import 'package:firebase_diplom/group/controller/add_group_controller.dart';
import 'package:firebase_diplom/group/database/database.dart';
import 'package:firebase_diplom/group/view/add_group_view.dart';
import 'package:firebase_diplom/group/view/student_list_in_group.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GroupController extends StatefulWidget {
  const GroupController({super.key});

  @override
  State<GroupController> createState() => _GroupControllerState();
}

class _GroupControllerState extends State<GroupController> {
  final DatabaseMethodsGroup databaseMethodsGroup = DatabaseMethodsGroup();
  late Stream<QuerySnapshot> groupStream;
  final nameGroupController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final maxCountStudentController = TextEditingController();
  final priceMonthController = TextEditingController();
  String? selectedDirectionController;
  String? selectedCityController;
  String? selectedTeacherController;

  @override
  void initState() {
    super.initState();
    _loadGroupStream();
  }

  Future<void> _loadGroupStream() async {
    groupStream = databaseMethodsGroup.getGroupDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Группы'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGroupController(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: groupStream,
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
              return _buildGroupTile(ds);
            },
          );
        },
      ),
    );
  }

  Widget _buildGroupTile(DocumentSnapshot ds) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: ListTile(
        title: Text('Название: ${ds['GroupName']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Направление: ${ds['GroupDirection']}'),
            Text('Город: ${ds['GroupCity']}'),
            Text(
                'Дата с: ${DateFormat('dd-MM-yyyy').format((ds['StartDate'] as Timestamp).toDate())}'),
            Text(
                'Дата до: ${DateFormat('dd-MM-yyyy').format((ds['EndDate'] as Timestamp).toDate())}'),
            Text('Учитель: ${ds['GroupTeacher']}'),
            Text('Макс. кол-во студентов: ${ds['MaxCountStudent']}'),
            Text('Цена в месяц: ${ds['PriceMonth']} сом'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                _showEditDialog(ds.id, ds);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteGroup(ds.id);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentListInGroupView(groupId: ds.id),
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(String id, DocumentSnapshot ds) {
    selectedDirectionController = ds['GroupDirection'];
    nameGroupController.text = ds['GroupName'];
    selectedCityController = ds['GroupCity'];
    startDateController.text = DateFormat('dd-MM-yyyy').format((ds['StartDate'] as Timestamp).toDate());
    endDateController.text = DateFormat('dd-MM-yyyy').format((ds['EndDate'] as Timestamp).toDate());
    selectedTeacherController = ds['GroupTeacher'];
    maxCountStudentController.text = ds['MaxCountStudent'].toString();
    priceMonthController.text = ds['PriceMonth'].toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редактирование группы'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFormField('Название группы', nameGroupController),
                _buildCityDropdown(),
                _buildDateFormField('Дата с', startDateController),
                _buildDateFormField('Дата до', endDateController),
                _buildTeacherDropdown(),
                _buildTextFormField('Максимальное количество студентов', maxCountStudentController),
                _buildTextFormField('Цена в месяц', priceMonthController),
                _buildDirectionDropdown(),
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
                Map<String, dynamic> groupInfoMap = {
                  "GroupName": nameGroupController.text,
                  "GroupDirection": selectedDirectionController,
                  "GroupCity": selectedCityController,
                  'StartDate': DateFormat('dd-MM-yyyy').parse(startDateController.text),
                  "EndDate": DateFormat('dd-MM-yyyy').parse(endDateController.text),
                  'GroupTeacher': selectedTeacherController,
                  'MaxCountStudent': int.parse(maxCountStudentController.text),
                  'PriceMonth': double.parse(priceMonthController.text),
                };
                await databaseMethodsGroup.updateGroupDetail(id, groupInfoMap);
                Navigator.pop(context);
              },
              child: Text('Сохранить'),
            )
          ],
        );
      },
    );
  }

  Future<void> _deleteGroup(String id) async {
    try {
      await databaseMethodsGroup.deleteGroupDetail(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Группа удалена успешно'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Удаление группы не удалось: $e'),
        ),
      );
    }
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
            labelText: 'Учитель',
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
}
