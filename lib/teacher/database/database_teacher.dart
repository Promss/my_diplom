import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethodsTeacher {
  Stream<QuerySnapshot> getTeacherDetails() {
    return FirebaseFirestore.instance.collection("Teacher").snapshots();
  }

  Future<bool> doesTeacherExist(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Teacher").doc(id).get();
    return snapshot.exists;
  }

  Future<void> addTeacherDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<void> updateTeacherDetail(
      String id, Map<String, dynamic> updateInfo) async {
    if (await doesTeacherExist(id)) {
      await FirebaseFirestore.instance
          .collection("Teacher")
          .doc(id)
          .update(updateInfo);
    } else {
      print("Преподаватель с ID $id не найден!");
    }
  }

  Future<void> deleteTeacherDetail(String id) async {
    if (await doesTeacherExist(id)) {
      await FirebaseFirestore.instance.collection("Teacher").doc(id).delete();
    } else {
      print("Преподаватель с ID $id не найден!");
    }
  }
}