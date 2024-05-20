import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/services/database.dart';
import 'package:firebase_diplom/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({super.key});

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  Color _directionBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
  final directionController = TextEditingController();
  Stream? DirectionStream;

  getontheload() async {
    DirectionStream = await DatabaseMethods().getDirectionDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allDirectionDetails() {
    return StreamBuilder(
        stream: DirectionStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    MediaQueryData queryData = MediaQuery.of(context);
                    double screenWidth = queryData.size.width;
                    double screenHeight = queryData.size.height;
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(ds['Direction']),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      directionController.text =
                                          ds['Direction'];
                                      EditDirectionDetail(ds['ID']);
                                    },
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await DatabaseMethods()
                                            .deleteDirectionDetail(ds['ID']);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.green,
                                      )),
                                  SizedBox(
                                    width: screenWidth / 100,
                                  )
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            print(ds['Direction']);
                          },
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(103, 80, 165, 1),
          onPressed: () {
            // ignore: avoid_print
            print('Добавление');
            context.go('/addScreens/direction');
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
              // ignore: avoid_print
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
          ),
          title: const Text('Сотрудники'),
          centerTitle: false,
        ),
        body: Column(
          children: [Expanded(child: allDirectionDetails())],
        ));
  }

  Future EditDirectionDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                        Text('Редактирование'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Направление'),
                    TextFormField(
                      controller: directionController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 10),
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
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updateInfo = {
                            'ID': id,
                            'Direction': directionController.text,
                          };
                          await DatabaseMethods()
                              .updateDirectionDetail(id, updateInfo)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text('Обновить'))
                  ],
                ),
              ),
            ),
          ));
}
