import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String id;
  String surname;
  String name;
  String patronymic;
  String email;
  String phone;
  String cityId;
  String source;
  String directionId;
  String teacherId;
  double prepayment;
  bool hasLaptop;
  String comment;

  Student({
    required this.id,
    required this.surname,
    required this.name,
    required this.patronymic,
    required this.email,
    required this.phone,
    required this.cityId,
    required this.source,
    required this.directionId,
    required this.teacherId,
    required this.prepayment,
    required this.hasLaptop,
    required this.comment,
  });

  factory Student.fromMap(Map<String, dynamic> data) {
    return Student(
      id: data['ID'],
      surname: data['Surname'],
      name: data['Name'],
      patronymic: data['Patronymic'],
      email: data['Email'],
      phone: data['Phone'],
      cityId: data['CityID'],
      source: data['Source'],
      directionId: data['DirectionID'],
      teacherId: data['TeacherID'],
      prepayment: data['Prepayment'],
      hasLaptop: data['HasLaptop'],
      comment: data['Comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Surname': surname,
      'Name': name,
      'Patronymic': patronymic,
      'Email': email,
      'Phone': phone,
      'CityID': cityId,
      'Source': source,
      'DirectionID': directionId,
      'TeacherID': teacherId,
      'Prepayment': prepayment,
      'HasLaptop': hasLaptop,
      'Comment': comment,
    };
  }
}
