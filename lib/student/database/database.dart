import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethodsStudent {
  Stream<QuerySnapshot> getStudentDetails() {
    return FirebaseFirestore.instance.collection("Student").snapshots();
  }

  Future<bool> doesStudentExist(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Student").doc(id).get();
    return snapshot.exists;
  }

  Future<void> addStudentDetails(
      Map<String, dynamic> studentInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(id)
        .set(studentInfoMap);
  }

  Future<void> updateStudentDetail(
      String id, Map<String, dynamic> updateInfo) async {
    if (await doesStudentExist(id)) {
      await FirebaseFirestore.instance
          .collection("Student")
          .doc(id)
          .update(updateInfo);
    } else {
      print("Студент с ID $id не найден!");
    }
  }

  Future<void> deleteStudentDetail(String id) async {
    if (await doesStudentExist(id)) {
      await FirebaseFirestore.instance.collection("Student").doc(id).delete();
    } else {
      print("Студент с ID $id не найден!");
    }
  }
}
