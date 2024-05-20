import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Employee')
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return await FirebaseFirestore.instance.collection("Employee").snapshots();
  }

  Future<bool> doesEmployeeExist(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Employee").doc(id).get();
    return snapshot.exists;
  }

  Future updateEmployeeDetail(
      String id, Map<String, dynamic> updateInfo) async {
    if (await doesEmployeeExist(id)) {
      return await FirebaseFirestore.instance
          .collection("Employee")
          .doc(id)
          .update(updateInfo);
    } else {
      // Обработайте случай, когда документ не найден (например, покажите сообщение об ошибке)
      print("Сотрудник с ID $id не найден!");
      return null; // Или покажите сообщение об ошибке пользователю
    }
  }

  Future deleteEmployeeDetail(
      String id) async {
    if (await doesEmployeeExist(id)) {
      return await FirebaseFirestore.instance
          .collection("Employee")
          .doc(id).delete();
    } else {
      // Обработайте случай, когда документ не найден (например, покажите сообщение об ошибке)
      print("Сотрудник с ID $id не найден!");
      return null; // Или покажите сообщение об ошибке пользователю
    }
  }
}
