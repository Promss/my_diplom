import 'package:firebase_diplom/group/database/database.dart';
import 'package:firebase_diplom/group/model/model.dart';
import 'package:firebase_diplom/group/view/group_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';// Импортируйте ваш файл model.dart

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
    return GroupView(
        groupStream: groupStream,
        onDeleteGroup: (id) async {
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
                content: Text('Удаление группы не успешна: $e'),
              ),
            );
          }
        },
        onEditGroup: (DocumentSnapshot ds) {
          selectedDirectionController = ds['GroupDirection'];
          nameGroupController.text = ds['GroupName'];
          selectedCityController = ds['GroupCity'];
          startDateController.text = DateFormat('dd-MM-yyyy').format((ds['StartDate'] as Timestamp).toDate());
          endDateController.text = DateFormat('dd-MM-yyyy').format((ds['EndDate'] as Timestamp).toDate());
          selectedTeacherController = ds['GroupTeacher'];
          maxCountStudentController.text = ds['MaxCountStudent'].toString();
          priceMonthController.text = ds['PriceMonth'].toString();
          _showEditDialog(ds.id);
        });
  }

  void _showEditDialog(String id) {
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
                _buildTextFormField('Город', TextEditingController()..text = selectedCityController ?? ''),
                _buildDateFormField('Дата с', startDateController),
                _buildDateFormField('Дата до', endDateController),
                _buildTextFormField('Учитель', TextEditingController()..text = selectedTeacherController ?? ''),
                _buildTextFormField('Максимальное количество студентов', maxCountStudentController),
                _buildTextFormField('Цена в месяц', priceMonthController),
                // Добавьте другие необходимые поля
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
                Group updatedGroup = Group(
                  id: id,
                  name: nameGroupController.text,
                  direction: selectedDirectionController!,
                  city: selectedCityController!,
                  startDate: DateFormat('dd-MM-yyyy').parse(startDateController.text),
                  endDate: DateFormat('dd-MM-yyyy').parse(endDateController.text),
                  teacher: selectedTeacherController!,
                  maxCountStudent: int.parse(maxCountStudentController.text),
                  priceMonth: double.parse(priceMonthController.text),
                );
                await databaseMethodsGroup.updateGroupDetail(id, updatedGroup.toMap());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Группа обновлена успешно'),
                  ),
                );
              },
              child: Text('Сохранить'),
            )
          ],
        );
      },
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
}