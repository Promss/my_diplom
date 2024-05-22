// models/employee.dart
class Employee {
  String id;
  String surname;
  String name;
  String patronymic;
  String phoneNumber;
  String position;

  Employee({
    required this.id,
    required this.surname,
    required this.name,
    required this.patronymic,
    required this.phoneNumber,
    required this.position,
  });

  factory Employee.fromMap(Map<String, dynamic> data) {
    return Employee(
      id: data['ID'],
      surname: data['Surname'],
      name: data['Name'],
      patronymic: data['Patronymic'],
      phoneNumber: data['PhoneNumber'],
      position: data['Position'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Surname': surname,
      'Name': name,
      'Patronymic': patronymic,
      'PhoneNumber': phoneNumber,
      'Position': position,
    };
  }
}
