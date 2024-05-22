import 'package:firebase_diplom/direction/database/database_direction.dart';
import 'package:firebase_diplom/direction/view/add_direction_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AddDirectionController extends StatelessWidget {
  const AddDirectionController({super.key});

  @override
  Widget build(BuildContext context) {
    return AddDirectionView(onAddDirection: (id, directionInFoMap) async {
      DatabaseMethodsDirection databaseMethodsDirection =
          DatabaseMethodsDirection();
      await databaseMethodsDirection
          .addDirectionDetails(directionInFoMap, id)
          .then((onValue) {
        Fluttertoast.showToast(
          msg: 'Добавлено',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        context.go('/mainScreen/direction');
      });
    });
  }
}
