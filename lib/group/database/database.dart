import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethodsGroup {
  Stream<QuerySnapshot> getGroupDetails() {
    return FirebaseFirestore.instance.collection("Group").snapshots();
  }

  Future<bool> doesGroupExist(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Group").doc(id).get();
    return snapshot.exists;
  }

  Future<void> addGroupDetails(
      Map<String, dynamic> groupInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection('Group')
        .doc(id)
        .set(groupInfoMap);
  }

  Future<void> updateGroupDetail(
      String id, Map<String, dynamic> updateInfo) async {
    if (await doesGroupExist(id)) {
      await FirebaseFirestore.instance
          .collection("Group")
          .doc(id)
          .update(updateInfo);
    } else {
      print("Группа с ID $id не найдена!");
    }
  }

  Future<void> deleteGroupDetail(String id) async {
    if (await doesGroupExist(id)) {
      await FirebaseFirestore.instance.collection("Group").doc(id).delete();
    } else {
      print("Группа с ID $id не найдена!");
    }
  }

  Future<void> addExistingStudentToGroup(String groupId, String studentId) async {
    DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance.collection('Student').doc(studentId).get();
    await FirebaseFirestore.instance
        .collection('Group')
        .doc(groupId)
        .collection('Students')
        .doc(studentId)
        .set(studentSnapshot.data() as Map<String, dynamic>);
  }

  Stream<QuerySnapshot> getStudentsInGroup(String groupId) {
    return FirebaseFirestore.instance
        .collection('Group')
        .doc(groupId)
        .collection('Students')
        .snapshots();
  }
}
