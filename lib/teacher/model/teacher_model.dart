import 'dart:ffi';

class Teacher {
  String id;
  String surname;
  String name;
  String patronymic;
  String email;
  String phoneNumber;
  String address;
  Int numberPatent;
  String teacherDirection;

  Teacher({
    required this.id,
    required this.surname,
    required this.name,
    required this.patronymic,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.numberPatent,
    required this.teacherDirection,
  });

  factory Teacher.fromMap(Map<String, dynamic> data) {
    return Teacher(
        id: data['ID'],
        surname: data['Surname'],
        name: data['Name'],
        patronymic: data['Patronymic'],
        email: data['Email'],
        phoneNumber: data['PhoneNumber'],
        address: data['Address'],
        numberPatent: data['NumberPatent'],
        teacherDirection: data['TeacherDirection']);
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Surname': surname,
      'Name': name,
      'Patronymic': patronymic,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'Address': address,
      'NumberPatent': numberPatent,
      'TeacherDirection': teacherDirection,
    };
  }
}
