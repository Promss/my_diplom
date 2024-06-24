
import 'package:firebase_diplom/student/database/database.dart';
import 'package:firebase_diplom/student/model/student_model.dart';
import 'package:firebase_diplom/student/view/add_student_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentController extends StatefulWidget {
  const StudentController({super.key});

  @override
  State<StudentController> createState() => _StudentControllerState();
}

class _StudentControllerState extends State<StudentController> {
  final DatabaseMethodsStudent databaseMethodsStudent = DatabaseMethodsStudent();
  late Stream<QuerySnapshot> studentStream;
  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final patronymicController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedCityController;
  final sourceController = TextEditingController();
  String? selectedDirectionController;
  String? selectedTeacherController;
  final prepaymentController = TextEditingController();
  bool hasLaptop = false;
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudentStream();
  }

  Future<void> _loadStudentStream() async {
    studentStream = databaseMethodsStudent.getStudentDetails();
    setState(() {});
  }

  Future<String> _getCityName(String cityId) async {
    DocumentSnapshot citySnapshot = await FirebaseFirestore.instance.collection('City').doc(cityId).get();
    return citySnapshot['CityName'];
  }

  Future<String> _getDirectionName(String directionId) async {
    DocumentSnapshot directionSnapshot = await FirebaseFirestore.instance.collection('Direction').doc(directionId).get();
    return directionSnapshot['Direction'];
  }

  Future<String> _getTeacherSurname(String teacherId) async {
    DocumentSnapshot teacherSnapshot = await FirebaseFirestore.instance.collection('Teacher').doc(teacherId).get();
    return teacherSnapshot['Surname'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Студенты'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentView(
                onAddStudent: (id, studentInfoMap) async {
                  await databaseMethodsStudent.addStudentDetails(studentInfoMap, id);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: studentStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Нет данных'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return FutureBuilder(
                future: Future.wait([
                  _getCityName(ds['CityID']),
                  _getDirectionName(ds['DirectionID']),
                  _getTeacherSurname(ds['TeacherID'])
                ]),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return ListTile(
                      title: Text('Ошибка загрузки данных'),
                    );
                  }
                  return _buildStudentTile(ds, snapshot.data![0], snapshot.data![1], snapshot.data![2]);
                }
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentTile(DocumentSnapshot ds, String cityName, String directionName, String teacherSurname) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Фамилия: ${ds['Surname']}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text('Имя: ${ds['Name']}'),
            SizedBox(height: 4.0),
            Text('Отчество: ${ds['Patronymic']}'),
            SizedBox(height: 4.0),
            Text('Почта: ${ds['Email']}'),
            SizedBox(height: 4.0),
            Text('Номер телефона: ${ds['Phone']}'),
            SizedBox(height: 4.0),
            Text('Город: $cityName'),
            SizedBox(height: 4.0),
            Text('Откуда узнал: ${ds['Source']}'),
            SizedBox(height: 4.0),
            Text('Направление: $directionName'),
            SizedBox(height: 4.0),
            Text('Преподаватель: $teacherSurname'),
            SizedBox(height: 4.0),
            Text('Сумма предоплаты: ${ds['Prepayment']}'),
            SizedBox(height: 4.0),
            Text('Есть ноутбук: ${ds['HasLaptop'] ? "Да" : "Нет"}'),
            SizedBox(height: 4.0),
            Text('Комментарий: ${ds['Comment']}'),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    surnameController.text = ds['Surname'];
                    nameController.text = ds['Name'];
                    patronymicController.text = ds['Patronymic'];
                    emailController.text = ds['Email'];
                    phoneController.text = ds['Phone'];
                    selectedCityController = ds['CityID'];
                    sourceController.text = ds['Source'];
                    selectedDirectionController = ds['DirectionID'];
                    selectedTeacherController = ds['TeacherID'];
                    prepaymentController.text = ds['Prepayment'].toString();
                    hasLaptop = ds['HasLaptop'];
                    commentController.text = ds['Comment'];
                    _showEditDialog(ds.id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteStudent(ds.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редактирование студента'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextFormField('Фамилия', surnameController),
                _buildTextFormField('Имя', nameController),
                _buildTextFormField('Отчество', patronymicController),
                _buildTextFormField('Почта', emailController),
                _buildTextFormField('Номер телефона', phoneController),
                _buildCityDropdown(),
                _buildTextFormField('Откуда о нас узнал', sourceController),
                _buildDirectionDropdown(),
                _buildTeacherDropdown(),
                _buildTextFormField('Сумма предоплаты', prepaymentController),
                _buildLaptopRadio(),
                _buildTextFormField('Комментарий', commentController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                Student updatedStudent = Student(
                  id: id,
                  surname: surnameController.text,
                  name: nameController.text,
                  patronymic: patronymicController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  cityId: selectedCityController!,
                  source: sourceController.text,
                  directionId: selectedDirectionController!,
                  teacherId: selectedTeacherController!,
                  prepayment: double.parse(prepaymentController.text),
                  hasLaptop: hasLaptop,
                  comment: commentController.text,
                );
                await databaseMethodsStudent.updateStudentDetail(id, updatedStudent.toMap());
                Navigator.pop(context);
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteStudent(String id) async {
    try {
      await databaseMethodsStudent.deleteStudentDetail(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Студент удален успешно'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Удаление студента не удалось: $e'),
        ),
      );
    }
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('City').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var cities = snapshot.data!.docs;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Город',
            border: OutlineInputBorder(),
          ),
          value: selectedCityController,
          onChanged: (String? newValue) {
            setState(() {
              selectedCityController = newValue!;
            });
          },
          items: cities.map((city) {
            return DropdownMenuItem<String>(
              value: city.id,
              child: Text(city['CityName']),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDirectionDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Direction').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var directions = snapshot.data!.docs;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Направление',
            border: OutlineInputBorder(),
          ),
          value: selectedDirectionController,
          onChanged: (String? newValue) {
            setState(() {
              selectedDirectionController = newValue!;
            });
          },
          items: directions.map((direction) {
            return DropdownMenuItem<String>(
              value: direction.id,
              child: Text(direction['Direction']),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTeacherDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Teacher').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var teachers = snapshot.data!.docs;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Преподаватель',
            border: OutlineInputBorder(),
          ),
          value: selectedTeacherController,
          onChanged: (String? newValue) {
            setState(() {
              selectedTeacherController = newValue!;
            });
          },
          items: teachers.map((teacher) {
            return DropdownMenuItem<String>(
              value: teacher.id,
              child: Text(teacher['Surname']),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLaptopRadio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('Есть ноутбук'),
          Radio(
            value: true,
            groupValue: hasLaptop,
            onChanged: (bool? value) {
              setState(() {
                hasLaptop = value!;
              });
            },
          ),
          Text('Да'),
          Radio(
            value: false,
            groupValue: hasLaptop,
            onChanged: (bool? value) {
              setState(() {
                hasLaptop = value!;
              });
            },
          ),
          Text('Нет'),
        ],
      ),
    );
  }
}
