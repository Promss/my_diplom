import 'package:firebase_diplom/group/database/database.dart';
import 'package:firebase_diplom/group/view/add_group_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddGroupController extends StatelessWidget {
  const AddGroupController({super.key});

  @override
  Widget build(BuildContext context) {
    return AddGroupView(
      onAddGroup: (id, groupInfoMap) async {
        DatabaseMethodsGroup databaseMethods = DatabaseMethodsGroup();
        await databaseMethods
            .addGroupDetails(groupInfoMap, id)
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
