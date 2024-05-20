import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdditionItems {
  final String label;

  AdditionItems(this.label);
}

List<AdditionItems> listAddition = [
  AdditionItems('Группа'),
  AdditionItems('Студент'),
  AdditionItems('Преподаватель'),
  AdditionItems('Направление'),
  AdditionItems('Заявка'),
  AdditionItems('Сотрудник'),
];

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление'),
        centerTitle: false,
        toolbarHeight: screenHeight / 14,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth / 30,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            for (AdditionItems element in listAddition)
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Card(
                  child: Container(
                    margin: EdgeInsets.only(left: screenWidth / 16),
                    height: screenHeight / 15,
                    alignment: const Alignment(-0.8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(element.label),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_right,
                            size: screenHeight / 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  if (element.label == 'Сотрудник') {
                    context.go('/addScreens/employee');
                  } else if (element.label == 'Направление') {
                    context.go('/addScreens/direction');
                  }
                  // ignore: avoid_print
                  print(element.label);
                },
              )
          ],
        ),
      ),
    );
  }
}
