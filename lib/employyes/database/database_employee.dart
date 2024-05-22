import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethodsEmployee {
  Stream<QuerySnapshot> getEmployeeDetails() {
    return FirebaseFirestore.instance.collection("Employee").snapshots();
  }

  Future<bool> doesEmployeeExist(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Employee").doc(id).get();
    return snapshot.exists;
  }

  Future<void> addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection('Employee')
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<void> updateEmployeeDetail(
      String id, Map<String, dynamic> updateInfo) async {
    if (await doesEmployeeExist(id)) {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(id)
          .update(updateInfo);
    } else {
      print("Сотрудник с ID $id не найден!");
    }
  }

  Future<void> deleteEmployeeDetail(String id) async {
    if (await doesEmployeeExist(id)) {
      await FirebaseFirestore.instance.collection("Employee").doc(id).delete();
    } else {
      print("Сотрудник с ID $id не найден!");
    }
  }
}