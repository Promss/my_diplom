import 'package:firebase_diplom/adds/view/add_screens.dart';
import 'package:firebase_diplom/home/view/home_screens.dart';
import 'package:firebase_diplom/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';

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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> _screens = [
    HomePage(),
    AddPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Добавить'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль')
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}