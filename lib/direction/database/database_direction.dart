import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethodsDirection{
  Future addDirectionDetails(
      Map<String, dynamic> directionInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Direction')
        .doc(id)
        .set(directionInfoMap);
  }

  Stream<QuerySnapshot> getDirectionDetails() {
    return FirebaseFirestore.instance.collection("Direction").snapshots();
  }

  Future<bool> doesDirectionExist(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Direction").doc(id).get();
    return snapshot.exists;
  }

  Future updateDirectionDetail(
      String id, Map<String, dynamic> updateInfo) async {
    if (await doesDirectionExist(id)) {
      return await FirebaseFirestore.instance
          .collection("Direction")
          .doc(id)
          .update(updateInfo);
    } else {
      // Обработайте случай, когда документ не найден (например, покажите сообщение об ошибке)
      print("Направление с ID $id не найден!");
      return null; // Или покажите сообщение об ошибке пользователю
    }
  }

  Future deleteDirectionDetail(String id) async {
    if (await doesDirectionExist(id)) {
      return await FirebaseFirestore.instance
          .collection("Direction")
          .doc(id)
          .delete();
    } else {
      // Обработайте случай, когда документ не найден (например, покажите сообщение об ошибке)
      print("Направление с ID $id не найден!");
      return null; // Или покажите сообщение об ошибке пользователю
    }
  }
}