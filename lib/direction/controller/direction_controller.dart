import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/direction/database/database_direction.dart';
import 'package:flutter/material.dart';
import 'package:firebase_diplom/direction/view/direction_view.dart';

class DirectionController extends StatefulWidget {
  const DirectionController({super.key});

  @override
  State<DirectionController> createState() => _DirectionControllerState();
}

class _DirectionControllerState extends State<DirectionController> {
  final DatabaseMethodsDirection databaseMethodsDirection =
      DatabaseMethodsDirection();
  late Stream<QuerySnapshot> directionStream;

  final TextEditingController directionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDirectionStream();
  }

  Future<void> _loadDirectionStream() async {
    directionStream = databaseMethodsDirection.getDirectionDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DirectioView(
      directionStream: directionStream,
      onDeleteDirection: (id) async {
        try {
          await databaseMethodsDirection.deleteDirectionDetail(id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Direction $id deleted successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete direction: $e')),
          );
        }
      },
      onEditDirection: (DocumentSnapshot ds) {
        directionController.text = ds['Direction'];
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
                _buildTextField('Направление', directionController),
                SizedBox(
                  height: 10,
                ),
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
                  'Direction': directionController.text,
                };
                await databaseMethodsDirection.updateDirectionDetail(
                    id, updateInfo);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Direction updated successfuly'),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              border: OutlineInputBorder()),
        )
      ],
    );
  }
}
