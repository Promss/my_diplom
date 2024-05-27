// add_employee_controller.dart

import 'package:firebase_diplom/employyes/database/database_employee.dart';
import 'package:firebase_diplom/employyes/view/add_employee_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AddEmployeeController extends StatelessWidget {
  const AddEmployeeController({super.key});

  @override
  Widget build(BuildContext context) {
    return AddEmployeeView(
      onAddEmployee: (id, employeeInfoMap) async {
        DatabaseMethodsEmployee databaseMethods = DatabaseMethodsEmployee();
        await databaseMethods
            .addEmployeeDetails(employeeInfoMap, id)
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
