import 'package:firebase_diplom/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

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
  final List<Employee> employees = [
    Employee(
        name: 'Айгуль',
        surname: 'Султанова',
        patronymic: 'Таштановна',
        phoneNumber: '+996-555-123-456',
        employeePosition: 'Администратор'),
    Employee(
        name: 'Эрмек',
        surname: 'Касымов',
        patronymic: 'Акматович',
        phoneNumber: '+996-777-987-654',
        employeePosition: 'SMM-менеджер'),
    Employee(
        name: 'Жылдыз',
        surname: 'Токтогулова',
        patronymic: 'Жакшыбековна',
        phoneNumber: '+996-701-234-567',
        employeePosition: 'Бухгалтер'),
    Employee(
        name: 'Бекболот',
        surname: 'Абдыкадыров',
        patronymic: 'Асылбекович',
        phoneNumber: '+996-770-876-543',
        employeePosition: 'Администратор')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          var employee = employees[index];
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(employee.surname),
                              Text(employee.name),
                              Text(employee.patronymic),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employee.phoneNumber),
                          Text(employee.employeePosition),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
                onTap: () {
                  print(employee.surname);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}