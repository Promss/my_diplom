import 'package:firebase_diplom/direction/controller/direction_controller.dart';
import 'package:firebase_diplom/employyes/controller/employee_controller.dart';
import 'package:firebase_diplom/group/controller/group_controller.dart';
import 'package:firebase_diplom/student/controller/student_controller.dart';
import 'package:firebase_diplom/teacher/controller/teacher_controller.dart';
import 'package:firebase_diplom/teacher/model/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubMenuList {
  final String icon;
  final String label;

  SubMenuList(this.icon, this.label);
}

List<SubMenuList> listSubMenu = [
  SubMenuList('assets/icons/groups.png', 'Группы'),
  SubMenuList('assets/icons/students.png', 'Студенты'),
  SubMenuList('assets/icons/teachers.png', 'Преподаватели'),
  SubMenuList('assets/icons/compas.png', 'Направления'),
  SubMenuList('assets/icons/waiting_list.png', 'Лист ожидания'),
  SubMenuList('assets/icons/employees.png', 'Сотрудники'),
  SubMenuList('assets/icons/archive.png', 'Архив'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth / 1000),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.history,
                  size: screenHeight / 30,
                )),
          ),
          Padding(
            padding: EdgeInsets.only(right: screenWidth / 50),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                size: screenHeight / 30,
              ),
            ),
          ),
        ],
        title: const Text('Главная'),
        centerTitle: false,
        toolbarHeight: screenHeight / 14,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
        child: GridView.count(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          crossAxisCount: 2,
          mainAxisSpacing: screenHeight / 100,
          crossAxisSpacing: screenWidth / 45,
          children: [
            for (SubMenuList element in listSubMenu)
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight / 15),
                    child: Column(children: [
                      Image.asset(
                        height: screenHeight / 30,
                        element.icon,
                      ),
                      Text(element.label)
                    ]),
                  ),
                ),
                onTap: () {
                  if (element.label == 'Сотрудники') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmployeesController()));
                  } else if (element.label == 'Направления') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DirectionController()));
                  } else if (element.label == 'Преподаватели') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherController()));
                  }else if (element.label == 'Группы'){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupController()));
                  }
                  else if (element.label == 'Студенты'){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentController()));
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}
