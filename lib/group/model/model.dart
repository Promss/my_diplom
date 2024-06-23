import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String id;
  String name;
  String direction;
  String city;
  DateTime startDate;
  DateTime endDate;
  String teacher;
  int maxCountStudent;
  double priceMonth;

  Group({
    required this.id,
    required this.name,
    required this.direction,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.teacher,
    required this.maxCountStudent,
    required this.priceMonth,
  });

  // Создание объекта Group из документа Firestore
  factory Group.fromMap(Map<String, dynamic>data) {
    return Group(
      id: data['ID'],
      name: data['GroupName'],
      direction: data['GroupDirection'],
      city: data['GroupCity'],
      startDate: (data['StartDate'] as Timestamp).toDate(),
      endDate: (data['EndDate'] as Timestamp).toDate(),
      teacher: data['GroupTeacher'],
      maxCountStudent: data['MaxCountStudent'],
      priceMonth: data['PriceMonth'].toDouble(),
    );
  }

  // Преобразование объекта Group в Map для отправки в Firestore
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'GroupName': name,
      'GroupDirection': direction,
      'GroupCity': city,
      'StartDate': Timestamp.fromDate(startDate),
      'EndDate': Timestamp.fromDate(endDate),
      'GroupTeacher': teacher,
      'MaxCountStudent': maxCountStudent,
      'PriceMonth': priceMonth,
    };
  }
}
