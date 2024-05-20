import 'package:firebase_diplom/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:random_string/random_string.dart';

class AddDirection extends StatefulWidget {
  const AddDirection({super.key});

  @override
  State<AddDirection> createState() => _AddDirectionState();
}

class _AddDirectionState extends State<AddDirection> {
  Color _directionBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
  final directionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Добавление направления'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/mainScreen');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 15, vertical: screenHeight / 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Направление'),
            TextFormField(
              controller: directionController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 50, horizontal: screenWidth / 50),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _directionBorderColor,
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Пожалуйста, введите направление.';
                }
                return null;
              },
            ),
            SizedBox(
              height: screenHeight / 50,
            ),
            SizedBox(
              width: double.maxFinite,
              height: screenHeight / 15,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: const Color.fromRGBO(103, 80, 165, 1.0)),
                onPressed: () async {
                  String id = randomAlphaNumeric(5);
                  Map<String, dynamic> directionInfoMap = {
                    "ID": id,
                    "Direction": directionController.text,
                  };
                  await DatabaseMethods()
                      .addDirectionDetails(directionInfoMap, id)
                      .then((value) {
                    Fluttertoast.showToast(
                        msg: 'Направление добавлено',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                },
                child: Text(
                  'Добавить',
                  style: TextStyle(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      fontSize: screenHeight / 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
