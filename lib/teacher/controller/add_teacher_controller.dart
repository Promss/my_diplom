import 'package:firebase_diplom/teacher/database/database_teacher.dart';
import 'package:firebase_diplom/teacher/view/add_teacher_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTeacherController extends StatelessWidget {
  const AddTeacherController({super.key});

  @override
  Widget build(BuildContext context) {
    return AddTeacherView(
      onAddTeacher: (id, employeeInfoMap) async {
        DatabaseMethodsTeacher databaseMethods = DatabaseMethodsTeacher();
        await databaseMethods
            .addTeacherDetails(employeeInfoMap, id)
            .then((value) {
          Fluttertoast.showToast(
            msg: "Добавлено",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pop(context);
        });
      },
    );
  }
}
