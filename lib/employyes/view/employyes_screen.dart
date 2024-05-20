import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/services/database.dart';
import 'package:firebase_diplom/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Employee {
  final String name;
  final String surname;
  final String patronymic;
  final String phoneNumber;
  final String employeePosition;

  Employee(
      {required this.name,
      required this.surname,
      required this.patronymic,
      required this.phoneNumber,
      required this.employeePosition});
}

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  Color _surnameBorderColor =
      Color.fromRGBO(103, 80, 165, 1.0); // Initial border color for email field
  Color _nameBorderColor = Color.fromRGBO(103, 80, 165, 1.0);
  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final patronymicController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final positionController = TextEditingController();
  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
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
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person_outline,
                                      size: 60,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(ds['Surname']),
                                        Text(ds['Name']),
                                        Text(ds['Patronymic']),
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
                                      surnameController.text = ds['Surname'];
                                      nameController.text = ds['Name'];
                                      patronymicController.text =
                                          ds['Patronymic'];
                                      phoneNumberController.text =
                                          ds['PhoneNumber'];
                                      positionController.text = ds['Position'];
                                      EditEmployeeDetail(ds['ID']);
                                    },
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await DatabaseMethods()
                                            .deleteEmployeeDetail(ds['ID']);
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
                              Padding(
                                padding: const EdgeInsets.only(left: 13.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ds['PhoneNumber']),
                                    Text(ds['Position']),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          onTap: () {
                            print(ds['Surname']);
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
          children: [Expanded(child: allEmployeeDetails())],
        ));
  }

  Future EditEmployeeDetail(String id) => showDialog(
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
                    Text('Фамилия'),
                    TextFormField(
                      controller: surnameController,
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
                            color: _surnameBorderColor,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Пожалуйста, введите фамилию.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Имя'),
                    TextFormField(
                      controller: nameController,
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
                            color: _nameBorderColor,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Пожалуйста, введите имя.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Отчество'),
                    TextFormField(
                      controller: patronymicController,
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
                            color: _nameBorderColor,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Номер телефона'),
                    TextFormField(
                      controller: phoneNumberController,
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
                            color: _nameBorderColor,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Пожалуйста, введите номер телефона.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Должность'),
                    TextFormField(
                      controller: positionController,
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
                            color: _nameBorderColor,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Пожалуйста, введите должность.';
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
                            'Surname': surnameController.text,
                            'Name': nameController.text,
                            'Patronymic': patronymicController.text,
                            'PhoneNumber': phoneNumberController.text,
                            'Position': positionController.text,
                          };
                          await DatabaseMethods()
                              .updateEmployeeDetail(id, updateInfo)
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
